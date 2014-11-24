//
//  PASectionViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASectionViewController.h"

#import "PAEmptyTableViewCell.h"
#import "PABasicInfoTableViewCell.h"
#import "PAStudentTableViewCell.h"
#import "PABasicTeacherTableViewCell.h"

#import "PASupercourseViewController.h"
#import "PATeacherViewController.h"
#import "PAStudentViewController.h"

NSString * NSStringFromSectionSections(PASectionTableViewSections section) {
    switch (section) {
        case PASectionTableViewSectionSupercourse:
            return @"Supercourse";
        case PASectionTableViewSectionTeacher:
            return @"Teacher";
        case PASectionTableViewSectionInfo:
            return @"Details";
        case PASectionTableViewSectionStudents:
            return @"Students";
        default:
            return nil;
    }
}

static NSString * kPASupercourseIdentifier = @"Supercourse";
static NSString * kPATeacherIdentifier = @"Teacher";
static NSString * kPAInfoIdentifier = @"Info";
static NSString * kPAStudentsIdentifier = @"Students";

@interface PASectionViewController ()

@property (nonatomic) NSUInteger sectionId;

@end

@implementation PASectionViewController

- (id)initWithSection:(PASection *)section {
    if (self = [super init]) {
        self.sectionId = section.sectionId;
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
        [[PASchedulesAPI sharedClient] sections:self.sectionId success:^(PASection *section) {
            self.navigationController.navigationBar.topItem.title = section.name;
            self.section = section;
            
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
    return NSStringFromSectionSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.section == nil ? 0 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PASectionTableViewSectionInfo) {
        return 3;
    }
    else return (section == PASectionTableViewSectionStudents) ? (self.section.students.count != 0 ? self.section.students.count : 1) : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASectionTableViewSectionStudents) {
        if (self.section.students.count != 0) {
            PAStudent *thisStudent = self.section.students[indexPath.row];
            return thisStudent.nickname ? 60 : 50;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASectionTableViewSectionSupercourse) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASupercourseIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPASupercourseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.section.supercourse.title;
        
        return cell;
    }
    else if (indexPath.section == PASectionTableViewSectionTeacher) {
        PABasicTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPATeacherIdentifier];
        cell = [PABasicTeacherTableViewCell cellWithReuseIdentifier:kPATeacherIdentifier];
        cell.teacher = self.section.teacher;
        
        return cell;
    }
    else if (indexPath.section == PASectionTableViewSectionInfo) {
        PABasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAInfoIdentifier];
        
        if (indexPath.row == 0) {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Name" andInfo:self.section.name];
        }
        else if (indexPath.row == 1) {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Period" andInfo:self.section.period];
        }
        else {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Section Size" andInfo:@(self.section.size)];
        }
        
        return cell;
    }
    else {
        if (self.section.students.count == 0) {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAStudentsIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPAStudentsIdentifier];
            cell.modelType = PAModelTypeStudent;
            
            return cell;
        }
        else {
            PAStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAStudentsIdentifier];
            cell = [PAStudentTableViewCell cellWithReuseIdentifier:kPAStudentsIdentifier];
            cell.student = self.section.students[indexPath.row];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASectionTableViewSectionSupercourse) {
        PASupercourse *aSupercourse = self.section.supercourse;
        
        PASupercourseViewController *supercourseController = [[PASupercourseViewController alloc] initWithSupercourse:aSupercourse];
        [self.navigationController pushViewController:supercourseController animated:YES];
    }
    else if (indexPath.section == PASectionTableViewSectionTeacher) {
        PATeacher *aTeacher = self.section.teacher;
        
        PATeacherViewController *teacherController = [[PATeacherViewController alloc] initWithTeacher:aTeacher];
        [self.navigationController pushViewController:teacherController animated:YES];
    }
    else if (indexPath.section == PASectionTableViewSectionStudents) {
        PAStudent *aStudent = self.section.students[indexPath.row];
        
        PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:aStudent];
        [self.navigationController pushViewController:studentController animated:YES];
    }
    else return;
}

@end