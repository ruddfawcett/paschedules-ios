//
//  PACompareViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACompareViewController.h"

#import "PAStudent.h"

#import "PAStudentViewController.h"
#import "PAComparisonViewController.h"

NSString * NSStringStringFromCompareSections(PACompareTableViewSections section) {
    switch (section) {
        case PACompareTableViewSectionStudents:
            return @"Select Students";
        default:
            return nil;
    }
}

static NSString * kPAStudentIdentifier = @"Student";
static NSString * kPAComparisonIdentifier = @"Comparison";

@interface PACompareViewController ()

@property (strong, nonatomic) PAStudent *firstStudent;
@property (strong, nonatomic) PAStudent *secondStudent;

@end

@implementation PACompareViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Find Comparisons";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableViewDelegates

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSStringStringFromCompareSections(section);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"Tap to change students.";
    }
    else return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == PACompareTableViewSectionStudents ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAComparisonIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPAComparisonIdentifier];
    
    if (indexPath.section == PACompareTableViewSectionStudents) {
        cell.textLabel.text = [NSString stringWithFormat:@"Student %ld",(long unsigned)indexPath.row+1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.userInteractionEnabled = NO;
        cell.textLabel.text = @"Compare";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PACompareTableViewSectionStudents) {
        PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:(indexPath.row == 0 ? self.firstStudent : self.secondStudent)];
        
        [self.navigationController pushViewController:studentController animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PACompareTableViewSectionStudents) {
        PAStudentSearchViewController *searchController = [[PAStudentSearchViewController alloc] initWithIndexPath:indexPath];
        searchController.delegate = self;
        
        [self.navigationController pushViewController:searchController animated:YES];
    }
    else {
        if (self.firstStudent && self.secondStudent) {
            PAComparisonViewController *compareController = [[PAComparisonViewController alloc] initWithStudent:self.firstStudent andStudent:self.secondStudent];
            
            PANavigationController *navigationController = [[PANavigationController alloc] initWithRootViewController:compareController];
            
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

#pragma mark - PAStudentSearchDelegate

- (void)studentSelected:(PAStudent *)student forIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.firstStudent = student;
    }
    else self.secondStudent = student;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.tintColor = PA_BLUE;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = student.nickname ? [NSString stringWithFormat:@"%@ (%@)",student.name,student.nickname] : [NSString stringWithFormat:@"%@",student.name];
    
    if (self.firstStudent && self.secondStudent) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.userInteractionEnabled = YES;
    }
}

@end
