//
//  PASectionViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASectionViewController.h"

#import "PASection.h"
#import "PAStudent.h"
#import "PASupercourse.h"
#import "PATeacher.h"

#import "PASupercourseViewController.h"
#import "PATeacherViewController.h"
#import "PAStudentViewController.h"

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
    if (section == PASectionTableViewSectionSupercourse) {
        return @"Supercourse";
    }
    else if (section == PASectionTableViewSectionTeacher) {
        return @"Teacher";
    }
    else if (section == PASectionTableViewSectionInfo) {
        return @"Details";
    }
    else {
        return @"Students";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.section == nil ? 0 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PASectionTableViewSectionInfo) {
        return 3;
    }
    else if (section == PASectionTableViewSectionStudents) {
        return self.section.students.count;
    }
    else {
        return 1;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASectionTableViewSectionInfo) {
        return UITableViewAutomaticDimension;
    }
    else if (indexPath.section == PASectionTableViewSectionStudents) {
        if (self.section.students.count == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            PAStudent *thisStudent = self.section.students[indexPath.row];
            
            if (thisStudent.nickname != nil) {
                return 60;
            }
            else {
                return 50;
            }
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resuseIdentifier];
    
    if (indexPath.section == PASectionTableViewSectionSupercourse) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        PASupercourse *thisSupercourse = self.section.supercourse;
        
        cell.textLabel.text = thisSupercourse.title;
    }
    else if (indexPath.section == PASectionTableViewSectionTeacher) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
        PATeacher *thisTeacher = self.section.teacher;
        
        cell.accessoryType = thisTeacher.name == nil ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = thisTeacher.name == nil ? NO : YES;
        cell.textLabel.text = thisTeacher.name == nil ? @"Not available." : thisTeacher.name;
        cell.textLabel.textColor = thisTeacher.name == nil ? [UIColor lightGrayColor] : [UIColor blackColor];
    }
    else if (indexPath.section == PASectionTableViewSectionInfo) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.section.name;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Period";
            cell.detailTextLabel.text = self.section.period;
        }
        else {
            cell.textLabel.text = @"Section Size";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.section.size];
        }
    }
    else {
        if (self.section.students.count == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]];
            cell.textLabel.text = @"No students.";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            PAStudent *thisStudent = self.section.students[indexPath.row];
            
            cell.textLabel.text = thisStudent.name;
            
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            if (thisStudent.nickname != nil) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Goes by %@.\nClass of %lu", thisStudent.nickname, (unsigned long)thisStudent.graduation];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Class of %lu", (unsigned long)thisStudent.graduation];
            }
        }
 
    }
    
    return cell;
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