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

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UITableViewController *tableViewController;

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) UIToolbar *toolbar;

@property (strong, nonatomic) NSArray *originalStudents;
@property (strong, nonatomic) NSArray *originalTeachers;
@property (strong, nonatomic) NSArray *originalSupercourses;

@property (strong, nonatomic) NSArray *studentsList;
@property (strong, nonatomic) NSArray *teachersList;
@property (strong, nonatomic) NSArray *supercoursesList;

@end

@implementation PASearchViewController

- (id)init {
    if (self = [super init]) {
    
    }
    
    return self;
}

- (void)viewDidLoad {
    self.title = @"Search";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self navigationBarFix];
    [self setUpToolbar];
    [self setUpTableView];
    [self loadList:PAAPIListTypeStudents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navBarHairlineImageView.hidden = NO;
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Setup

- (void)navigationBarFix {
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

- (void)setUpToolbar {
    NSArray *items = @[NSStringFromPAAPIListType(PAAPIListTypeStudents),
       NSStringFromPAAPIListType(PAAPIListTypeTeachers),
       @"Courses"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width-20, 30);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *segment = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
    self.toolbar = [UIToolbar new];
    
    CGRect toolbarFrame = self.navigationController.toolbar.frame;
    toolbarFrame.origin.y = toolbarFrame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.toolbar.frame = toolbarFrame;
    self.toolbar.items = @[flexibleItem, segment, flexibleItem];
    
    [self.view addSubview:self.toolbar];
    
}

- (void)setUpTableView {
    self.tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:self.tableViewController];

    self.tableViewController.view.frame = CGRectMake(0,
                                                self.toolbar.bounds.origin.y+self.toolbar.bounds.size.height,
                                                self.view.bounds.size.width,
                                                self.view.bounds.size.height - self.toolbar.bounds.size.height);

    self.tableViewController.refreshControl = [UIRefreshControl new];
    self.tableViewController.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.tableViewController.refreshControl addTarget:self action:@selector(loadList) forControlEvents:UIControlEventValueChanged];

    self.refreshControl = self.tableViewController.refreshControl;
    
    [self.refreshControl beginRefreshing];
    
    self.tableView = self.tableViewController.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view insertSubview:self.tableView belowSubview:self.toolbar];
}

#pragma mark - API

- (void)loadList {
    [self loadList:self.segmentedControl.selectedSegmentIndex];
}

- (void)loadList:(PAAPIListTypes)type {
    self.searchField.text = nil;
    
    [[PASchedulesAPI sharedClient] list:type success:^(NSArray *list) {
        if (type == PAAPIListTypeStudents) {
            self.originalStudents = list;
            self.studentsList = list;
        }
        else if (type == PAAPIListTypeTeachers) {
            self.originalTeachers = list;
            self.teachersList = list;
        }
        else {
            self.originalSupercourses = list;
            self.supercoursesList = list;
        }
        
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        [NSError showWithError:error];
    }];
}

#pragma mark - UITableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == PASearchTableViewSectionsType) {
        return NSStringFromPAAPIListType(self.segmentedControl.selectedSegmentIndex);
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == PASearchTableViewSectionsSearchField ? UITableViewAutomaticDimension : 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count;
    
    if (section == PASearchTableViewSectionsType) {
        if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
            count = self.studentsList.count;
        }
        else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
            count = self.teachersList.count;
        }
        else {
            count = self.supercoursesList.count;
        }
    }
    
    if (count == 0) count = 1;
    
    return section == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PATextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASearchIdentifier];
        cell = [PATextFieldCell cellWithReuseIdentifier:kPASearchIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.placeholder = @"Search Query";
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
                cell.modelType = PAModelTypeStudent;
                
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
                cell.modelType = PAModelTypeTeacher;
                
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
                cell.modelType = PAModelTypeSupercourse;
                
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
            PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:self.studentsList[indexPath.row]];
            [self.navigationController pushViewController:studentController animated:YES];
        }
        else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
            PATeacherViewController *teacherController = [[PATeacherViewController alloc] initWithTeacher:self.teachersList[indexPath.row]];
            [self.navigationController pushViewController:teacherController animated:YES];
        }
        else {
            PASupercourseViewController *supercourseController = [[PASupercourseViewController alloc] initWithSupercourse:self.supercoursesList[indexPath.row]];
            [self.navigationController pushViewController:supercourseController animated:YES];
        }
    }
}

#pragma mark - UISegmentedControlDelegate

- (void)segmentChanged {
    self.searchField.text = nil;
    self.studentsList = self.originalStudents;
    self.teachersList = self.originalTeachers;
    self.supercoursesList = self.originalSupercourses;
    
    if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeStudents) {
        if (!self.studentsList) {
            [self loadSegmentChange];
        }
        
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (self.segmentedControl.selectedSegmentIndex == PAAPIListTypeTeachers) {
        if (!self.teachersList) {
            [self loadSegmentChange];
        }
        
        [self reloadSection:PASearchTableViewSectionsType withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
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
    
    self.searchField.text = nil;
    [self.refreshControl beginRefreshing];
    [self loadList:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *query = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
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
            NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name contains[cd] '%@'",query]];
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
            NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name contains[cd] '%@'",query]];
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
            NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title contains[cd] '%@' OR name contains[cd] '%@'",query,query]];
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
