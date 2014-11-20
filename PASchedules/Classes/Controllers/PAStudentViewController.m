//
//  PAStudentViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAStudentViewController.h"

#import "PAStudent.h"
#import "PACourse.h"
#import "PACommitment.h"
#import "PASection.h"

#import "PASectionViewController.h"
#import "PACommitmentViewController.h"

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
        [[PASchedulesAPI sharedClient] students:self.studentId success:^(PAStudent *student) {
            self.navigationController.navigationBar.topItem.title = student.name;
            self.student = student;
            
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
    if (section == PAStudentTableViewSectionInfo) {
        return nil;
    }
    else if (section == PAStudentTableViewSectionCourses) {
        return @"Courses";
    }
    else {
        return @"Commitments";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.student == nil ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PAStudentTableViewSectionInfo) {
        if (self.student.nickname != nil) {
            return 2;
        }
        else return 1;
    }
    else if (section == PAStudentTableViewSectionCourses) {
        return self.student.courses.count;
    }
    else {
        return self.student.commitments.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAStudentTableViewSectionInfo) {
        return UITableViewAutomaticDimension;
    }
    else if (indexPath.section == PAStudentTableViewSectionCourses) {
        if (self.student.courses.count == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            PACourse *thisCourse = self.student.courses[indexPath.row];
            
            if (thisCourse.teacherName != nil) {
                return 60;
            }
            else {
                return 50;
            }
        }
    }
    else {
        if (self.student.commitments.count == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            return 60;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
    
    if (indexPath.section == PAStudentTableViewSectionInfo) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resuseIdentifier];
        PAStudent *thisStudent = self.student;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Graduation";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)thisStudent.graduation];
        }
        else {
            cell.textLabel.text = @"Goes by";
            cell.detailTextLabel.text = thisStudent.nickname;
        }
    }
    else if (indexPath.section == PAStudentTableViewSectionCourses) {
        if (self.student.courses.count == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]];
            cell.textLabel.text = @"No courses.";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            PACourse *thisCourse = self.student.courses[indexPath.row];
            
            cell.textLabel.text = thisCourse.sectionName;
            
            if (thisCourse.teacherName != nil) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ \n%@", thisCourse.teacherName, thisCourse.room];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", thisCourse.room];
            }
        }
    }
    else {
        if (self.student.courses.count == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]];
            cell.textLabel.text = @"No commitments.";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            PACommitment *thisCommitment = self.student.commitments[indexPath.row];
            
            cell.textLabel.text = thisCommitment.title;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ \n%@", thisCommitment.name, thisCommitment.teacherName];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAStudentTableViewSectionCourses) {
        PASection *aSection = [[PASection alloc] initWithAttributes:@{@"id" : @([self.student.courses[indexPath.row] sectionId])}];
        
        PASectionViewController *sectionViewController = [[PASectionViewController alloc] initWithSection:aSection];
        
        [self.navigationController pushViewController:sectionViewController animated:YES];
    }
    else if (indexPath.section == PAStudentTableViewSectionCommitments) {
        PACommitment *aCommitment = self.student.commitments[indexPath.row];
        
        PACommitmentViewController *commitmentViewController = [[PACommitmentViewController alloc] initWithCommitment:aCommitment];
        
        [self.navigationController pushViewController:commitmentViewController animated:YES];
    }
    else return;
}

@end
