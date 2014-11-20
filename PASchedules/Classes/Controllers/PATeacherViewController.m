//
//  PATeacherViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATeacherViewController.h"

#import "PASection.h"
#import "PAStudent.h"
#import "PASupercourse.h"
#import "PATeacher.h"

#import "PASectionViewController.h"

@interface PATeacherViewController ()

@property (nonatomic) NSUInteger teacherId;

@end

@implementation PATeacherViewController

- (id)initWithTeacher:(PATeacher *)teacher {
    if (self = [super init]) {
        self.teacherId = teacher.teacherId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self action:@selector(loadTeacher) forControlEvents:UIControlEventValueChanged];
    [self loadTeacher];
}

- (void)loadTeacher {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PASchedulesAPI sharedClient] teachers:self.teacherId success:^(PATeacher *teacher) {
            self.navigationController.navigationBar.topItem.title = teacher.name;
            self.teacher = teacher;
            
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
    if (section == PATeacherTableViewSectionInfo) {
        return @"Department";
    }
    else if (section == PATeacherTableViewSectionSections) {
        return @"Sections";
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.teacher == nil ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PATeacherTableViewSectionInfo) {
        return 1;
    }
    else if (section == PATeacherTableViewSectionSections) {
        return self.teacher.sections.count;
    }
    else {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherTableViewSectionInfo) {
        return UITableViewAutomaticDimension;
    }
    else if (indexPath.section == PATeacherTableViewSectionSections) {
        if (self.teacher.sections.count == 0) {
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resuseIdentifier];
    
    if (indexPath.section == PATeacherTableViewSectionInfo) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = self.teacher.department;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    else {
        if (self.teacher.sections.count == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]];
            cell.textLabel.text = @"No students.";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            PASection *thisSection = self.teacher.sections[indexPath.row];
            
            cell.textLabel.text = thisSection.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Period\n%lu students.", thisSection.period, (unsigned long)thisSection.size];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherTableViewSectionSections) {
        PASection *aSection = self.teacher.sections[indexPath.row];
        
        PASectionViewController *sectionController = [[PASectionViewController alloc] initWithSection:aSection];
        [self.navigationController pushViewController:sectionController animated:YES];
    }
}

@end
