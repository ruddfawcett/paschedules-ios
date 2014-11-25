//
//  PATeacherSearchViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/23/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATeacherSearchViewController.h"

#import "PAStudent.h"

#import "PATextFieldCell.h"
#import "PAEmptyTableViewCell.h"
#import "PATeacherTableViewCell.h"

#import "PATeacherViewController.h"

static NSString * kPASearchIdentifier = @"Search";
static NSString * kPAResultIdentifier = @"Result";

@interface PATeacherSearchViewController ()

@property (strong, nonatomic) UITextField *searchField;

@property (strong, nonatomic) NSArray *originalTeachers;
@property (strong, nonatomic) NSArray *teachersList;

@end

@implementation PATeacherSearchViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Teacher Seach";
    
    [self.refreshControl addTarget:self action:@selector(loadList) forControlEvents:UIControlEventValueChanged];
    [self loadList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)loadList {
    if ([self shouldLoadTeachers]) {
        [[PASchedulesAPI sharedClient] list:PAAPIListTypeTeachers success:^(NSArray *list) {
            self.originalTeachers = list;
            self.teachersList = list;
            [self reloadSection:PATeacherSearchTableViewSectionTeachers withRowAnimation:UITableViewRowAnimationFade];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [NSError showWithError:error];
        }];
    }
}

- (BOOL)shouldLoadTeachers {
    if ([PACache sharedCache].teachers) {
        self.originalTeachers = [PACache sharedCache].teachers;
        self.teachersList = [PACache sharedCache].teachers;
        [self reloadSection:PATeacherSearchTableViewSectionTeachers withRowAnimation:UITableViewRowAnimationFade];
        [self.refreshControl endRefreshing];
        
        return NO;
    }
    else return YES;
}

#pragma mark - UITableView

- (void)reloadSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sectionToReload withRowAnimation:rowAnimation];
}

#pragma mark - UITableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == PATeacherSearchTableViewSectionTeachers) {
        if (self.originalTeachers.count == self.teachersList.count) {
            return @"All Teachers";
        }
        else return @"Results";
    }
    
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *alphabets = [[NSMutableArray alloc] initWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    
    [alphabets removeLastObject];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherSearchTableViewSectionTeachers) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    
    if (section == PATeacherSearchTableViewSectionTeachers) {
        count = self.teachersList.count != 0 ? self.teachersList.count : 1;
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
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherSearchTableViewSectionTeachers) {
        PATeacherViewController *studentController = [[PATeacherViewController alloc] initWithTeacher:self.teachersList[indexPath.row]];
        [self.navigationController pushViewController:studentController animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.teachersList = self.originalTeachers;
    
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
    if (self.teachersList) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"search contains[cd] '%@'",query]];
        NSArray *filtered = [self.originalTeachers filteredArrayUsingPredicate:filter];
        
        self.teachersList = filtered;
        
        if ([query isEqualToString:@""]) {
            self.teachersList = self.originalTeachers;
        }
        
        [self reloadSection:PATeacherSearchTableViewSectionTeachers withRowAnimation:UITableViewRowAnimationFade];
    }
    else return;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


@end
