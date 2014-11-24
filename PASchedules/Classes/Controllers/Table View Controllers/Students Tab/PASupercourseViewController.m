//
//  PASupercourseViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASupercourseViewController.h"

#import "PABasicInfoTableViewCell.h"
#import "PAEmptyTableViewCell.h"
#import "PASectionTableViewCell.h"

#import "PASectionViewController.h"

NSString * NSStringFromSupercourseSections(PASupercourseTableViewSections section) {
    switch (section) {
        case PASupercourseTableViewSectionSections:
            return @"Sections";
        default:
            return nil;
    }
}

static NSString * kPAInfoIdentifier = @"Info";
static NSString * kPASectionsIdentifier = @"Section";

@interface PASupercourseViewController ()

@property (nonatomic) NSUInteger supercourseId;

@end

@implementation PASupercourseViewController

- (id)initWithSupercourse:(PASupercourse *)supercourse {
    if (self = [super init]) {
        self.supercourseId = supercourse.supercourseId;
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
        [[PASchedulesAPI sharedClient] supercourses:self.supercourseId success:^(PASupercourse *supercourse) {
            self.navigationController.navigationBar.topItem.title = supercourse.title;
            self.supercourse = supercourse;
            
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
    return NSStringFromSupercourseSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.supercourse == nil ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PASupercourseTableViewSectionSections) {
        return self.supercourse.sections.count != 0 ? self.supercourse.sections.count : 1;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASupercourseTableViewSectionSections) {
        if (self.supercourse.sections.count != 0) {
            PASection *thisSection = self.supercourse.sections[indexPath.row];
            
            return thisSection.teacher.name ? 60 : 50;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASupercourseTableViewSectionInfo) {
        PABasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPAInfoIdentifier];
        
        if (indexPath.row == 0) {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Name" andInfo:self.supercourse.name];
        }
        else {
            cell = [PABasicInfoTableViewCell cellWithReuseIdentifier:kPAInfoIdentifier andText:@"Sections" andInfo:@(self.supercourse.sections.count)];
        }
        
        return cell;
    }
    else {
        if (self.supercourse.sections.count != 0) {
            PASectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPASectionsIdentifier];
            cell = [PASectionTableViewCell cellWithReuseIdentifier:kPASectionsIdentifier];
            cell.section = self.supercourse.sections[indexPath.row];
            
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
    if (indexPath.section == PASupercourseTableViewSectionSections) {
        PASectionViewController *sectionViewController = [[PASectionViewController alloc] initWithSection:self.supercourse.sections[indexPath.row]];
        [self.navigationController pushViewController:sectionViewController animated:YES];
    }
}

@end
