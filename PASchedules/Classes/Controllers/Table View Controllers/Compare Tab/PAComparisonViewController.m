//
//  PAComparisonViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/24/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAComparisonViewController.h"

#import "PATeacher.h"
#import "PAStudent.h"
#import "PACourse.h"
#import "PACommitment.h"

#import "PAEmptyTableViewCell.h"
#import "PACourseTableViewCell.h"
#import "PATeacherTableViewCell.h"
#import "PACommitmentTableViewCell.h"

#import "PASectionViewController.h"
#import "PATeacherViewController.h"
#import "PACommitmentViewController.h"

static NSString * kPACourseIdentifier = @"Course";
static NSString * kPATeacherIdentifier = @"Teacher";
static NSString * kPACommitmentIdentifier = @"Commitment";

@interface PAComparisonViewController ()

@property (nonatomic, getter=isLoading) BOOL loading;

@property (strong, nonatomic) PAStudent *firstStudent;
@property (strong, nonatomic) PAStudent *secondStudent;

@property (strong, nonatomic) NSArray *sharedCourses;
@property (strong, nonatomic) NSArray *sharedTeachers;
@property (strong, nonatomic) NSArray *sharedCommitments;

@end

@implementation PAComparisonViewController

- (id)initWithStudent:(PAStudent *)firstStudent andStudent:(PAStudent *)secondStudent {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.firstStudent = firstStudent;
        self.secondStudent = secondStudent;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.title = @"Results";
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(loadStudents) forControlEvents:UIControlEventValueChanged];
    [self loadStudents];
}

#pragma mark - API Methods

- (void)loadStudents {
    self.loading = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PASchedulesAPI sharedClient] students:self.firstStudent.studentId success:^(PAStudent *student) {
            self.firstStudent = student;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to load students."}];
            
            [NSError showWithError:error];
        }];
        
        [[PASchedulesAPI sharedClient] students:self.secondStudent.studentId success:^(PAStudent *student) {
            self.secondStudent = student;
            self.loading = NO;
            
            [self compare:self.firstStudent withStudent:self.secondStudent];
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to load students."}];
            
            [NSError showWithError:error];
        }];
    });
}

#pragma mark - "Fun" comparison logic:

- (void)compare:(PAStudent *)student withStudent:(PAStudent *)studentTwo {
    NSMutableArray *sharedCourses = [@[] mutableCopy];
    NSMutableArray *sharedTeachers = [@[] mutableCopy];
    NSMutableArray *sharedCommitments = [@[] mutableCopy];
    
    for (PACourse *eachCourse in student.courses) {
        if ([[NSArray arrayOfCourseIds:studentTwo.courses] containsObject:[NSNumber numberWithInt:eachCourse.sectionId]]) {
            [sharedCourses addObject:eachCourse];
        }
        
        if ([[NSArray arrayOfTeacherNames:studentTwo.courses] containsObject:eachCourse.teacherName]) {
            [[PASchedulesAPI sharedClient] sections:eachCourse.sectionId success:^(PASection *section) {
                [sharedTeachers addObject:section.teacher];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to load teachers."}];
                
                [NSError showWithError:error];
            }];
        }
    }
    
    for (PACommitment *eachCommitment in student.commitments) {
        if ([[NSArray arrayOfCommitmentIds:studentTwo.commitments] containsObject:[NSNumber numberWithInt:eachCommitment.commitmentId]]) {
            [sharedCommitments addObject:eachCommitment];
        }
    }
    
    self.sharedCourses = sharedCourses;
    self.sharedTeachers = sharedTeachers;
    self.sharedCommitments = sharedCommitments;
}

#pragma mark - UITableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.sharedCourses.count != 0) {
            return 60;
        }
        else return UITableViewAutomaticDimension;
    }
    else if (indexPath.section == 1) {
        if (self.sharedTeachers.count != 0) {
            return 50;
        }
        else return UITableViewAutomaticDimension;
    }
    else {
        if (self.sharedCommitments.count != 0) {
            return 60;
        }
        else return UITableViewAutomaticDimension;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Shared Courses";
    }
    return section == 1 ? @"Shared Teachers" : @"Shared Commitments";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.loading ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sharedCourses.count != 0 ? self.sharedCourses.count : 1;
    }
    else if (section == 1) {
        return self.sharedTeachers.count != 0 ? self.sharedTeachers.count : 1;
    }
    else return self.sharedCommitments.count != 0 ? self.sharedCommitments.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.sharedCourses.count != 0) {
            PACourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACourseIdentifier];
            cell = [PACourseTableViewCell cellWithReuseIdentifier:kPACourseIdentifier];
            cell.course = self.sharedCourses[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACourseIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPACourseIdentifier];
            cell.search = YES;
            cell.imageView.image = nil;
            cell.modelType = PAModelTypeCourse;
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (self.sharedTeachers.count != 0) {
            PATeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPATeacherIdentifier];
            cell = [PATeacherTableViewCell cellWithReuseIdentifier:kPATeacherIdentifier];
            cell.teacher = self.sharedTeachers[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPATeacherIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPACourseIdentifier];
            cell.search = YES;
            cell.imageView.image = nil;
            cell.modelType = PAModelTypeTeacher;
            
            return cell;
        }
    }
    else {
        if (self.sharedCommitments.count != 0) {
            PACommitmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACommitmentIdentifier];
            cell = [PACommitmentTableViewCell cellWithReuseIdentifier:kPACommitmentIdentifier];
            cell.commitment = self.sharedCommitments[indexPath.row];
            
            return cell;
        }
        else {
            PAEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPACommitmentIdentifier];
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPACourseIdentifier];
            cell.search = YES;
            cell.imageView.image = nil;
            cell.modelType = PAModelTypeCommitment;
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PASectionViewController *sectionViewController = [[PASectionViewController alloc] initWithSection:[[PASection alloc] initWithAttributes:@{@"id" : @([self.sharedCourses[indexPath.row] sectionId])}]];
        [self.navigationController pushViewController:sectionViewController animated:YES];
    }
    else if (indexPath.section == 1) {
        PATeacherViewController *teacherViewController = [[PATeacherViewController alloc] initWithTeacher:self.sharedTeachers[indexPath.row]];
        [self.navigationController pushViewController:teacherViewController animated:YES];
    }
    else {
        PACommitmentViewController *commitmentController = [[PACommitmentViewController alloc] initWithCommitment:self.sharedCommitments[indexPath.row]];
        [self.navigationController pushViewController:commitmentController animated:YES];
    }
}

@end
