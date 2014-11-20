//
//  PASupercourseViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASupercourseViewController.h"

#import "PASupercourse.h"
#import "PASection.h"
#import "PATeacher.h"

#import "PASectionViewController.h"

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
    if (section == PASupercourseTableViewSectionInfo) {
        return nil;
    }
    else {
        return @"Sections";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.supercourse == nil ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PASupercourseTableViewSectionSections) {
        return self.supercourse.sections.count;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASupercourseTableViewSectionInfo) {
        return UITableViewAutomaticDimension;
    }
    else {
        if (self.supercourse.sections.count == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            PASection *thisSection = self.supercourse.sections[indexPath.row];
            
            if (thisSection.teacher.name != nil) {
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
    
    if (indexPath.section == PASupercourseTableViewSectionInfo) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:resuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.supercourse.name];

        }
        else {
            cell.textLabel.text = @"Sections";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.supercourse.sections.count];

        }
    }
    else {
        if (self.supercourse.sections.count == 0) {
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
            
            PASection *thisSection = self.supercourse.sections[indexPath.row];
            
            cell.textLabel.text = thisSection.name;
            
            if (thisSection.teacher.name != nil) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ \n%@ Period", thisSection.teacher.name, thisSection.period];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Period", thisSection.period];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASupercourseTableViewSectionSections) {
        PASection *aSection = self.supercourse.sections[indexPath.row];
        
        PASectionViewController *sectionViewController = [[PASectionViewController alloc] initWithSection:aSection];
        
        [self.navigationController pushViewController:sectionViewController animated:YES];
    }
}

@end
