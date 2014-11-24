//
//  PAStudentSearchViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/23/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAStudentSearchViewController.h"

#import "PAStudent.h"

#import "PATextFieldCell.h"
#import "PAEmptyTableViewCell.h"
#import "PAStudentTableViewCell.h"

#import "PAStudentViewController.h"

static NSString * kPASearchIdentifier = @"Search";
static NSString * kPAResultIdentifier = @"Result";

@interface PAStudentSearchViewController ()

@property (strong, nonatomic) UITextField *searchField;

@property (strong, nonatomic) NSArray *originalStudents;
@property (strong, nonatomic) NSArray *studentsList;

@end

@implementation PAStudentSearchViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self action:@selector(loadList) forControlEvents:UIControlEventValueChanged];
    [self loadList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)loadList {
    [[PASchedulesAPI sharedClient] list:PAAPIListTypeStudents success:^(NSArray *list) {
            self.originalStudents = list;
            self.studentsList = list;
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        [NSError showWithError:error];
    }];
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
    if (section == PAStudentSearchTableViewSectionStudents) {
            if (self.originalStudents.count == self.studentsList.count) {
                return @"All Students";
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
    if (indexPath.section == PAStudentSearchTableViewSectionStudents) {
        if (self.studentsList.count != 0) {
            return [self.studentsList[indexPath.row] nickname] ? 60 : 50;
        }
        else return UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    
    if (section == PAStudentSearchTableViewSectionStudents) {
        count = self.studentsList.count != 0 ? self.studentsList.count : 1;
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
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAStudentSearchTableViewSectionStudents) {
        PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:self.studentsList[indexPath.row]];
        [self.navigationController pushViewController:studentController animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.studentsList = self.originalStudents;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self search:self.searchField.text];
}

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
    if (self.studentsList) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"search contains[cd] '%@'",query]];
        NSArray *filtered = [self.originalStudents filteredArrayUsingPredicate:filter];
        
        self.studentsList = filtered;
        
        if ([query isEqualToString:@""]) {
            self.studentsList = self.originalStudents;
        }
        
        [self reloadSection:PAStudentSearchTableViewSectionStudents withRowAnimation:UITableViewRowAnimationFade];
    }
    else return;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


@end
