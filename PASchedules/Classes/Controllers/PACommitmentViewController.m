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
    
    [self.refreshControl addTarget:self action:@selector(loadSection) forControlEvents:UIControlEventValueChanged];
    [self loadSection];
}

- (void)loadSection {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PASchedulesAPI sharedClient] commitments:self.commitmentId success:^(PACommitment *commitment) {
            self.navigationController.navigationBar.topItem.title = commitment.title;
            self.commitment = commitment;
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [NSError showWithError:error];
        }];
    });
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSStringFromCommitmentSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commitment == nil ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PACommitmentTableViewSectionInfo) {
        return 2;
    }
    else if (section == PACommitmentTableViewSectionStudents) {
        return self.commitment.students.count;
    }
    else {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PACommitmentTableViewSectionStudents) {
        if (self.commitment.students.count != 0) {
            PAStudent *thisStudent = self.commitment.students[indexPath.row];
            return thisStudent.nickname ? 60 : 50;
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
        
        if (indexPath.row == 0) {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Name" andInfo:self.commitment.name];
        }
        else {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Commitment Size" andInfo:@(self.commitment.size)];
        }
        
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
