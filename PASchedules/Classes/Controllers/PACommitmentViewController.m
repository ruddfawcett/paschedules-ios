//
//  PACommitmentViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACommitmentViewController.h"

#import "PACommitment.h"
#import "PAStudent.h"

#import "PAStudentViewController.h"

@interface PACommitmentViewController ()

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
    if (section == PACommitmentTableViewSectionSupervisor) {
        return @"Supervisor";
    }
    else if (section == PACommitmentTableViewSectionStudents) {
        return @"Students";
    }
    
    return nil;
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
        if (self.commitment.students.count == 0) {
            return UITableViewAutomaticDimension;
        }
        else {
            PAStudent *thisStudent = self.commitment.students[indexPath.row];
            
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
    
    if (indexPath.section == PACommitmentTableViewSectionSupervisor) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = self.commitment.teacherName == nil ? @"Not available." : self.commitment.teacherName;
        cell.textLabel.textColor = self.commitment.teacherName == nil ? [UIColor lightGrayColor] : [UIColor blackColor];
    }
    else if (indexPath.section == PACommitmentTableViewSectionInfo) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.commitment.name;
        }
        else {
            cell.textLabel.text = @"Commitment Size";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.commitment.size];
        }
    }
    else {
        if (self.commitment.students.count == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]];
            cell.textLabel.text = @"No students.";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            PAStudent *thisStudent = self.commitment.students[indexPath.row];
            
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
    if (indexPath.section == PACommitmentTableViewSectionStudents) {
        PAStudent *aStudent = self.commitment.students[indexPath.row];
        
        PAStudentViewController *studentController = [[PAStudentViewController alloc] initWithStudent:aStudent];
        [self.navigationController pushViewController:studentController animated:YES];
    }
}

@end
