//
//  PASupercourseSearchViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/23/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASupercourseSearchViewController.h"

#import "PASupercourse.h"

#import "PATextFieldCell.h"
#import "PAEmptyTableViewCell.h"
#import "PASupercourseTableViewCell.h"

#import "PASupercourseViewController.h"

static NSString * kPASearchIdentifier = @"Search";
static NSString * kPAResultIdentifier = @"Result";

@interface PASupercourseSearchViewController ()

@property (strong, nonatomic) UITextField *searchField;

@property (strong, nonatomic) NSArray *originalSupercourses;
@property (strong, nonatomic) NSArray *supercoursesList;

@end

@implementation PASupercourseSearchViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Course Seach";
    
    [self.refreshControl addTarget:self action:@selector(loadList) forControlEvents:UIControlEventValueChanged];
    [self loadList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)loadList {
    if ([self shouldLoadSupercourses]) {
        [[PASchedulesAPI sharedClient] list:PAAPIListTypeSupercourses success:^(NSArray *list) {
            self.originalSupercourses = list;
            self.supercoursesList = list;
            [self reloadSection:PASupercourseSearchTableViewSectionSupercourses withRowAnimation:UITableViewRowAnimationFade];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [[PAError sharedError] showWithError:error];
        }];
    }
}

- (BOOL)shouldLoadSupercourses {
    if ([PACache sharedCache].supercourses) {
        self.originalSupercourses = [PACache sharedCache].supercourses;
        self.supercoursesList = [PACache sharedCache].supercourses;
        [self reloadSection:PASupercourseSearchTableViewSectionSupercourses withRowAnimation:UITableViewRowAnimationFade];
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
    if (section == PASupercourseSearchTableViewSectionSupercourses) {
        if (self.originalSupercourses.count == self.supercoursesList.count) {
            return @"All Supercourses";
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
    if (indexPath.section == PASupercourseSearchTableViewSectionSupercourses) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    
    if (section == PASupercourseSearchTableViewSectionSupercourses) {
        count = self.supercoursesList.count != 0 ? self.supercoursesList.count : 1;
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
            cell.modelType = PAModelTypeStudent;
            cell.imageView.image = nil;
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASupercourseSearchTableViewSectionSupercourses) {
        PASupercourseViewController *supercourseController = [[PASupercourseViewController alloc] initWithSupercourse:self.supercoursesList[indexPath.row]];
        [self.navigationController pushViewController:supercourseController animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
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
    if (self.supercoursesList) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"search contains[cd] '%@'",query]];
        NSArray *filtered = [self.originalSupercourses filteredArrayUsingPredicate:filter];
        
        self.supercoursesList = filtered;
        
        if ([query isEqualToString:@""]) {
            self.supercoursesList = self.originalSupercourses;
        }
        
        [self reloadSection:PASupercourseSearchTableViewSectionSupercourses withRowAnimation:UITableViewRowAnimationFade];
    }
    else return;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


@end
