//
//  PATeacherViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATeacherViewController.h"

#import "PAEmptyTableViewCell.h"
#import "PASectionTableViewCell.h"

#import "PASectionViewController.h"


NSString * NSStringFromTeacherSections(PATeacherTableViewSections section) {
    switch (section) {
        case PATeacherTableViewSectionInfo:
            return @"Department";
        case PATeacherTableViewSectionSections:
            return @"Sections";
        default:
            return nil;
    }
}

static NSString * kPAInfoIdentifier = @"Info";
static NSString * kPASectionsIdentifier = @"Sections";

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
        [[PASchedulesAPI sharedClient] teachers:self.teacherId track:YES success:^(PATeacher *teacher) {
            self.navigationController.navigationBar.topItem.title = teacher.name;
            self.teacher = teacher;
            
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
    if (section == PATeacherTableViewSectionSections) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromTeacherSections(section), (unsigned long)self.teacher.sections.count];
    }
    
    return NSStringFromTeacherSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.teacher == nil ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PATeacherTableViewSectionInfo) {
        return 1;
    }
    else if (section == PATeacherTableViewSectionSections) {
        return self.teacher.sections.count != 0 ? self.teacher.sections.count : 1;
    }
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherTableViewSectionSections) {
        return self.teacher.sections.count != 0 ? 60 : UITableViewAutomaticDimension;
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherTableViewSectionInfo) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAInfoIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPAInfoIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = self.teacher.department;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        return cell;
    }
    else {
        if (self.teacher.sections.count != 0) {
            PASectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASectionsIdentifier];
            cell = [PASectionTableViewCell cellWithReuseIdentifier:kPASectionsIdentifier];
            cell.section = self.teacher.sections[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASectionsIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPASectionsIdentifier];
            cell.modelType = PAModelTypeSection;
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PATeacherTableViewSectionSections) {
        PASection *aSection = self.teacher.sections[indexPath.row];
        
        PASectionViewController *sectionController = [[PASectionViewController alloc] initWithSection:aSection];
        [self.navigationController pushViewController:sectionController animated:YES];
    }
}

@end
