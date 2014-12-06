//
//  PACommitmentViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACommitmentViewController.h"

#import "PABasicTeacherTableViewCell.h"
#import "PABasicInfoTableViewCell.h"
#import "PAEmptyTableViewCell.h"
#import "PAStudentTableViewCell.h"

#import "PAStudentViewController.h"

NSString * NSStringFromCommitmentSections(PACommitmentTableViewSections section) {
    switch (section) {
        case PACommitmentTableViewSectionSupervisor:
            return @"Supervisor";
        case PACommitmentTableViewSectionStudents:
            return @"Students";
        default:
            return nil;
    }
}

static NSString * kPASupervisorIdentifier = @"Supervisor";
static NSString * kPAInfoIdentifier = @"Info";
static NSString * kPAStudentIdentifier = @"Student";

@interface PACommitmentViewController ()

/**
 *  The commitmentId of the commitment this controller represents.
 */
@property (nonatomic) NSUInteger commitmentId;

@end

@implementation PACommitmentViewController

- (id)initWithCommitment:(PACommitment *)commitment {
    if (self = [super init]) {
        self.commitmentId = commitment.commitmentId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self action:@selector(loadCommitment) forControlEvents:UIControlEventValueChanged];
    [self loadCommitment];
}

- (void)loadCommitment {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PASchedulesAPI sharedClient] commitments:self.commitmentId track:YES success:^(PACommitment *commitment) {
            self.navigationController.navigationBar.topItem.title = commitment.title;
            self.commitment = commitment;
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [[PAError sharedError] showWithError:error];
        }];
    });
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == PACommitmentTableViewSectionStudents) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromCommitmentSections(section), (unsigned long)self.commitment.students.count];
    }
    
    return NSStringFromCommitmentSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commitment == nil ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PACommitmentTableViewSectionStudents) {
        return self.commitment.students.count != 0 ? self.commitment.students.count : 1;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PACommitmentTableViewSectionStudents) {
        if (self.commitment.students.count != 0) {
            return 50;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PACommitmentTableViewSectionSupervisor) {
        PABasicTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASupervisorIdentifier];
        cell = [PABasicTeacherTableViewCell cellWithReuseIdentifier:kPASupervisorIdentifier];
        cell.teacher = self.commitment.teacher;
        
        return cell;
    }
    else if (indexPath.section == PACommitmentTableViewSectionInfo) {
        PABasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAInfoIdentifier];
        cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Name" andInfo:self.commitment.name];
        
        return cell;
    }
    else {
        if (self.commitment.students.count != 0) {
            PAStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAStudentIdentifier];
            cell = [PAStudentTableViewCell cellWithReuseIdentifier:kPAStudentIdentifier];
            cell.student = self.commitment.students[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAStudentIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPAStudentIdentifier];
            cell.modelType = PAModelTypeStudent;
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PACommitmentTableViewSectionStudents) {
        PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:self.commitment.students[indexPath.row]];
        [self.navigationController pushViewController:studentController animated:YES];
    }
}

@end
