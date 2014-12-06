//
//  PASearchViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/21/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASearchViewController.h"

#import "PAStudentTableViewCell.h"
#import "PATeacherTableViewCell.h"
#import "PASupercourseTableViewCell.h"
#import "PATextFieldCell.h"
#import "PAEmptyTableViewCell.h"

#import "PAStudentViewController.h"
#import "PATeacherViewController.h"
#import "PASupercourseViewController.h"

static NSString * kPASearchIdentifier = @"Search";
static NSString * kPAResultIdentifier = @"Result";

@interface PASearchViewController ()

@property (strong, nonatomic) UITextField *searchField;

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSArray *originalStudents;
@property (strong, nonatomic) NSArray *originalTeachers;
@property (strong, nonatomic) NSArray *originalSupercourses;

@property (strong, nonatomic) NSArray *studentsList;
@property (strong, nonatomic) NSArray *teachersList;
@property (strong, nonatomic) NSArray *supercoursesList;

@end

@implementation PASearchViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self action:@selector(loadList) forControlEvents:UIControlEventValueChanged];
    
    [self.refreshControl beginRefreshing];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self setNeedsStatusBarAppearanceUpdate];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    [self setUpSegment];
    [self loadList:PAAPIListTypeStudents];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Setup

- (void)setUpSegment {
    NSArray *items = @[NSStringFromPAAPIListType(PAAPIListTypeStudents),
                       NSStringFromPAAPIListType(PAAPIListTypeTeachers),
                       @"Courses"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.segmentedControl;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - API

- (void)loadList {
    [self loadList:self.segmentedControl.selectedSegmentIndex];
}

- (void)loadList:(PAAPIListTypes)type {
    if ([self shouldLoadList:type]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[PASchedulesAPI sharedClient] list:type success:^(NSArray *list) {
                if (type == PAAPIListTypeStudents) {
                    [PACache sharedCache].students = list;
                    self.originalStudents = list;
                    self.studentsList = list;
                }
                else if (type == PAAPIListTypeTeachers) {
                    [PACache sharedCache].teachers = list;
                    self.originalTeachers = list;
                    self.teachersList = list;
                }
                else {
                    [PACache sharedCache].supercourses = list;
                    self.originalSupercourses = list;
                    self.supercoursesList = list;
                }
                
                [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
                [self.refreshControl endRefreshing];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.refreshControl endRefreshing];
                [[PAError sharedError] showWithError:error];
            }];
        });
    }
}

- (BOOL)shouldLoadList:(PAAPIListTypes)type {
    BOOL result;
    
    if (type == PAAPIListTypeStudents) {
        if ([PACache sharedCache].students.count) {
            self.originalStudents = [PACache sharedCache].students;
            self.studentsList = [PACache sharedCache].students;
            
            result = NO;
        }
        else result = YES;
    }
    else if (type == PAAPIListTypeTeachers) {
        if ([PACache sharedCache].teachers) {
            self.originalTeachers = [PACache sharedCache].teachers;
            self.teachersList = [PACache sharedCache].teachers;
            
            result = NO;
        }
        else result = YES;
    }
    else {
        if ([PACache sharedCache].supercourses) {
            self.originalSupercourses = [PACache sharedCache].supercourses;
            self.supercoursesList = [PACache sharedCache].supercourses;
            
            result = NO;
        }
        else result = YES;
    }
    
    if (!result) {
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
        [self.refreshControl endRefreshing];
    }
    
    return result;
}

#pragma mark - UITableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == PASearchTableViewSectionsType) {
        if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
            if (self.originalStudents.count == self.studentsList.count) {
                return [NSString stringWithFormat:@"All %@",NSStringFromPAAPIListType(self.segmentedControl.selectedSegmentIndex)];
            }
            else return @"Results";
        }
        else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
            if (self.originalTeachers.count == self.teachersList.count) {
                return [NSString stringWithFormat:@"All %@",NSStringFromPAAPIListType(self.segmentedControl.selectedSegmentIndex)];
            }
            else return @"Results";
            
        }
        else {
            if (self.originalSupercourses.count == self.originalSupercourses.count) {
                return @"All Courses";
            }
            else return @"Results";
        }
    }
    
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *alphabets = [[NSMutableArray alloc] initWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    
    [alphabets removeLastObject];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASearchTableViewSectionsType) {
        if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
            if (self.studentsList.count != 0) {
                return [self.studentsList[indexPath.row] nickname] ? 60 : 50;
            }
            else return UITableViewAutomaticDimension;
        }
        else return 50;
    }
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    
    if (section == PASearchTableViewSectionsType) {
        if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
            if (self.originalStudents.count != 0) {
                count = self.studentsList.count == 0 ? 1 : self.studentsList.count;
            }
            else count = 0;
        }
        else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
            if (self.originalTeachers.count != 0) {
                count = self.teachersList.count == 0 ? 1 : self.teachersList.count;
            }
            else count = 0;
        }
        else {
            if (self.originalSupercourses.count != 0) {
                count = self.supercoursesList.count == 0 ? 1 : self.supercoursesList.count;
            }
            else count = 0;
        }
    }
    
    return section == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PATextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASearchIdentifier];
        cell = [PATextFieldCell cellWithReuseIdentifier:kPASearchIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.placeholder = @"Search";
        cell.textField.clearButtonMode = UITextFieldViewModeNever;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.delegate = self;
        
        self.searchField = cell.textField;
        
        return cell;
    }
    else {
        if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
            if (self.studentsList.count != 0) {
                PAStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAResultIdentifier];
                cell = [PAStudentTableViewCell cellWithReuseIdentifier:kPAResultIdentifier];
                cell.student = self.studentsList[indexPath.row];
                
                return cell;
            }
            else {
                PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAResultIdentifier];
                cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPAResultIdentifier];
                cell.search = YES;
                cell.modelType = PAModelTypeStudent;
                cell.imageView.image = nil;
                
                return cell;
            }
        }
        else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
            if (self.teachersList.count != 0) {
                PATeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAResultIdentifier];
                cell = [PATeacherTableViewCell cellWithReuseIdentifier:kPAResultIdentifier];
                cell.teacher = self.teachersList[indexPath.row];
                
                return cell;
            }
            else {
                PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAResultIdentifier];
                cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPAResultIdentifier];
                cell.search = YES;
                cell.modelType = PAModelTypeTeacher;
                cell.imageView.image = nil;
                
                return cell;
            }
        }
        else {
            if (self.supercoursesList.count != 0) {
                PASupercourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAResultIdentifier];
                cell = [PASupercourseTableViewCell cellWithReuseIdentifier:kPAResultIdentifier];
                cell.supercourse = self.supercoursesList[indexPath.row];
                
                return cell;
            }
            else {
                PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAResultIdentifier];
                cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPAResultIdentifier];
                cell.search = YES;
                cell.modelType = PAModelTypeSupercourse;
                cell.imageView.image = nil;
                
                return cell;
            }
        }
    }
    
    return nil;
}

- (void)reloadSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sectionToReload withRowAnimation:rowAnimation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASearchTableViewSectionsType) {
        if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
            PAStudent *theStudent = self.studentsList[indexPath.row];
            PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:theStudent];
            
            if (![self.searchField.text isEqualToString:@""]) {
                [Mixpanel track:@"Student Searched" properties:@{@"Subject" : @{@"Name" : theStudent.name, @"ID": @(theStudent.studentId)}, @"Search Query" : self.searchField.text}];
            }
            [self.navigationController pushViewController:studentController animated:YES];
        }
        else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
            PATeacher *theTeacher = self.teachersList[indexPath.row];
            PATeacherViewController *teacherController = [[PATeacherViewController alloc] initWithTeacher:theTeacher];
            
            if (![self.searchField.text isEqualToString:@""]) {
                [Mixpanel track:@"Teacher Searched" properties:@{@"Subject" : @{@"Name" : theTeacher.name, @"ID": @(theTeacher.teacherId)}, @"Search Query" : self.searchField.text}];
            }
            [self.navigationController pushViewController:teacherController animated:YES];
        }
        else {
            PASupercourse *theSupercourse = self.supercoursesList[indexPath.row];
            PASupercourseViewController *supercourseController = [[PASupercourseViewController alloc] initWithSupercourse:theSupercourse];
            
            if (![self.searchField.text isEqualToString:@""]) {
                [Mixpanel track:@"Supercourse Searched" properties:@{@"Subject" : @{@"Name" : theSupercourse.title, @"ID": @(theSupercourse.supercourseId)}, @"Search Query" : self.searchField.text}];
            }
            [self.navigationController pushViewController:supercourseController animated:YES];
        }
    }
}

#pragma mark - UISegmentedControlDelegate

- (void)segmentChanged {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    self.studentsList = self.originalStudents;
    self.teachersList = self.originalTeachers;
    self.supercoursesList = self.originalSupercourses;
    
    if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
        // self.searchField.placeholder = @"Search by name, graduation or both.";
        
        if (!self.studentsList) {
            [self loadSegmentChange];
        }
        
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
        // self.searchField.placeholder = @"Search by name, department or both.";
        if (!self.teachersList) {
            [self loadSegmentChange];
        }
        
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        // self.searchField.placeholder = @"Search by course, code or both.";
        if (!self.supercoursesList) {
            [self loadSegmentChange];
        }
        
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)loadSegmentChange {
    self.studentsList = self.originalStudents;
    self.teachersList = self.originalTeachers;
    self.supercoursesList = self.originalSupercourses;
    
    [self.refreshControl beginRefreshing];
    [self loadList:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.studentsList = self.originalStudents;
    self.teachersList = self.originalTeachers;
    self.supercoursesList = self.originalSupercourses;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self search:self.searchField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *query = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self search:query];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    return NO;
}

- (void)search:(NSString *)query {
    if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
        if (self.studentsList) {
            NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"search contains[cd] '%@'",query]];
            NSArray *filtered = [self.originalStudents filteredArrayUsingPredicate:filter];
            
            self.studentsList = filtered;
            
            if ([query isEqualToString:@""]) {
                self.studentsList = self.originalStudents;
            }
            
            [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
        }
        else return;
    }
    else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
        if (self.teachersList) {
            NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"search contains[cd] '%@'",query]];
            NSArray *filtered = [self.originalTeachers filteredArrayUsingPredicate:filter];
            
            self.teachersList = filtered;
            
            if ([query isEqualToString:@""]) {
                self.teachersList = self.originalTeachers;
            }
            
            [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
        }
        else return;
    }
    else {
        if (self.supercoursesList) {
            NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"search contains[cd] '%@'",query]];
            NSArray *filtered = [self.originalSupercourses filteredArrayUsingPredicate:filter];
            
            self.supercoursesList = filtered;
            
            if ([query isEqualToString:@""]) {
                self.supercoursesList = self.originalSupercourses;
            }
            
            [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
        }
        else return;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end