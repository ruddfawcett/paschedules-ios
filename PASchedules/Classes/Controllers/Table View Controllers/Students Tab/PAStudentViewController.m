//
//  PAStudentViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAStudentViewController.h"

#import "PAEmptyTableViewCell.h"
#import "PABasicInfoTableViewCell.h"
#import "PACourseTableViewCell.h"
#import "PACommitmentTableViewCell.h"

#import "PASectionViewController.h"
#import "PACommitmentViewController.h"

NSString * NSStringFromStudentSections(PAStudentTableViewSections section) {
    switch (section) {
        case PAStudentTableViewSectionCourses:
            return @"Classes";
        case PAStudentTableViewSectionCommitments:
            return @"Commitments";
        default:
            return nil;
    }
}

static NSString * kPAInfoIdentifier = @"Info";
static NSString * kPAClassesIdentifier = @"Classes";
static NSString * kPACommitmentsIdentifier = @"Commitments";

@interface PAStudentViewController ()

@property (nonatomic) NSUInteger studentId;

@end

@implementation PAStudentViewController

- (id)initWithStudent:(PAStudent *)student {
    if (self = [super init]) {
        self.studentId = student.studentId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self action:@selector(loadStudent) forControlEvents:UIControlEventValueChanged];
    [self loadStudent];
}

- (void)loadStudent {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PASchedulesAPI sharedClient] students:self.studentId track:YES success:^(PAStudent *student) {
            self.navigationController.navigationBar.topItem.title = student.nickname ? [NSString stringWithFormat:@"%@ (%@)", student.name, student.nickname] : student.name;
            self.student = student;
            
            if ([PASchedulesAPI currentUser] && student.isCurrentStudent) {
                if (![PACache sharedCache].hasBeenUpdated) {
                    [Crashlytics setStudent:student];
                    [Mixpanel updateStudent:student];
                    [[PACache sharedCache] setHasBeenUpdated:YES];
                }
            }
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [NSError showWithError:error];
        }];
    });
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == PAStudentTableViewSectionCourses) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromStudentSections(section), (unsigned long)self.student.courses.count];
    }
    
    if (section == PAStudentTableViewSectionCommitments) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromStudentSections(section), (unsigned long)self.student.commitments.count];
    }
    
    return NSStringFromStudentSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.student == nil ? 1 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PAStudentTableViewSectionInfo) {
        return 1;
    }
    else if (section == PAStudentTableViewSectionCourses) {
        return self.student.courses.count != 0 ? self.student.courses.count : 1;
    }
    else return self.student.commitments.count !=0 ? self.student.commitments.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAStudentTableViewSectionCourses) {
        if (self.student.courses.count == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            PACourse *thisCourse = self.student.courses[indexPath.row];
            return thisCourse.teacherName ? 60 : 50;
        }
    }
    else if (indexPath.section == PAStudentTableViewSectionCommitments) {
        return (self.student.commitments.count != 0) ? 60 : UITableViewAutomaticDimension;
    }
    else return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAStudentTableViewSectionInfo) {
        if (self.student) {
            PABasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAInfoIdentifier];
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Graduation" andInfo:@(self.student.graduation)];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACommitmentsIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPACommitmentsIdentifier];
            cell.modelType = PAModelTypeStudent;
            
            cell.hidden = YES;
            
            return cell;
        }
    }
    else if (indexPath.section == PAStudentTableViewSectionCourses) {
        if (self.student.courses.count != 0) {
            PACourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAClassesIdentifier];
            cell = [PACourseTableViewCell cellWithReuseIdentifier:kPAClassesIdentifier];
            cell.course = self.student.courses[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAClassesIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPAClassesIdentifier];
            cell.modelType = PAModelTypeCourse;
            
            return cell;
        }
    }
    else {
        if (self.student.commitments.count != 0) {
            PACommitmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACommitmentsIdentifier];
            cell = [PACommitmentTableViewCell cellWithReuseIdentifier:kPACommitmentsIdentifier];
            cell.commitment = self.student.commitments[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACommitmentsIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPACommitmentsIdentifier];
            cell.modelType = PAModelTypeCommitment;
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAStudentTableViewSectionCourses) {
        PASectionViewController *sectionViewController = [[PASectionViewController alloc] initWithSection:[[PASection alloc] initWithAttributes:@{@"id" : @([self.student.courses[indexPath.row] sectionId])}]];
        [self.navigationController pushViewController:sectionViewController animated:YES];
    }
    else if (indexPath.section == PAStudentTableViewSectionCommitments) {
        PACommitmentViewController *commitmentViewController = [[PACommitmentViewController alloc] initWithCommitment:self.student.commitments[indexPath.row]];
        [self.navigationController pushViewController:commitmentViewController animated:YES];
    }
    else return;
}

@end
