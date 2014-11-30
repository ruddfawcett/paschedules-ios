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

NSString * NSStringFromComparisonSections(PAComparisonTableViewSections section) {
    switch (section) {
        case PAComparisonTableViewSectionCourses:
            return @"Shared Classes";
            break;
        case PAComparisonTableViewSectionTeachers:
            return @"Shared Teachers";
            break;
        default:
            return @"Shared Commitments";
            break;
    }
}

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
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.title = @"Results";
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(loadStudents) forControlEvents:UIControlEventValueChanged];
    [self loadStudents];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - API Methods

- (void)loadStudents {
    self.loading = YES;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
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
            
            [self compare:self.firstStudent withStudent:self.secondStudent completion:^(NSArray *sharedCourses, NSArray *sharedTeachers, NSArray *sharedCommitments) {
                self.sharedCourses = sharedCourses;
                self.sharedTeachers = sharedTeachers;
                self.sharedCommitments = sharedCommitments;
                
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshControl endRefreshing];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to load students."}];
            
            [NSError showWithError:error];
        }];
    });
}

#pragma mark - "Fun" comparison logic:

- (void)compare:(PAStudent *)student withStudent:(PAStudent *)studentTwo completion:(void (^)(NSArray *sharedCourses, NSArray *sharedTeachers, NSArray *sharedCommitments))completion {
    NSMutableArray *sharedCourses = [@[] mutableCopy];
    NSMutableArray *sharedTeacherIds = [@[] mutableCopy];
    NSMutableArray *sharedCommitments = [@[] mutableCopy];
    
    for (PACourse *eachCourse in student.courses) {
        if ([[NSArray arrayOfCourseIds:studentTwo.courses] containsObject:[NSNumber numberWithInteger:eachCourse.sectionId]]) {
            [sharedCourses addObject:eachCourse];
        }
        
        if ([[NSArray arrayOfTeacherNames:studentTwo.courses] containsObject:eachCourse.teacherName]) {
            [sharedTeacherIds addObject:@(eachCourse.sectionId)];
        }
    }
    
    for (PACommitment *eachCommitment in student.commitments) {
        if ([[NSArray arrayOfCommitmentIds:studentTwo.commitments] containsObject:[NSNumber numberWithInteger:eachCommitment.commitmentId]]) {
            [sharedCommitments addObject:eachCommitment];
        }
    }
    
    [self loadSections:sharedTeacherIds success:^(NSArray *teachers) {
        completion(sharedCourses, teachers, sharedCommitments);
    }];
    
}

- (void)loadSections:(NSArray *)sectionIds success:(void (^)(NSArray *teachers))success {
    __block NSMutableArray *teachers = [@[] mutableCopy];
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSNumber *sectionId in sectionIds) {
        dispatch_group_enter(group);
        [[PASchedulesAPI sharedClient] sections:[sectionId intValue] success:^(PASection *section) {
            [teachers addObject:section.teacher];

            dispatch_group_leave(group);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey : @"Failed to load some teachers."}];
            [NSError showWithError:error];
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        success(teachers);
    });
}

#pragma mark - UITableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAComparisonTableViewSectionCourses) {
        if (self.sharedCourses.count != 0) {
            return 60;
        }
        else return UITableViewAutomaticDimension;
    }
    else if (indexPath.section == PAComparisonTableViewSectionCommitments) {
        if (self.sharedCommitments.count != 0) {
            return 60;
        }
        else return UITableViewAutomaticDimension;
    }
    else return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == PAComparisonTableViewSectionCourses) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromComparisonSections(section), (unsigned long)self.sharedCourses.count];
    }
    
    if (section == PAComparisonTableViewSectionTeachers) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromComparisonSections(section), (unsigned long)self.sharedTeachers.count];
    }
    
    if (section == PAComparisonTableViewSectionCommitments) {
        return [NSString stringWithFormat:@"%@ (%lu)", NSStringFromComparisonSections(section), (unsigned long)self.sharedCommitments.count];
    }
    
    
    return NSStringFromComparisonSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.loading ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PAComparisonTableViewSectionCourses) {
        return self.sharedCourses.count != 0 ? self.sharedCourses.count : 1;
    }
    else if (section == PAComparisonTableViewSectionTeachers) {
        return self.sharedTeachers.count != 0 ? self.sharedTeachers.count : 1;
    }
    else return self.sharedCommitments.count != 0 ? self.sharedCommitments.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAComparisonTableViewSectionCourses) {
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
    else if (indexPath.section == PAComparisonTableViewSectionTeachers) {
        if (self.sharedTeachers.count != 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPATeacherIdentifier];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPATeacherIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [self.sharedTeachers[indexPath.row] name];
            
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
            cell = [PAEmptyTableViewCell cellWithReuseIdentifier:kPACommitmentIdentifier];
            cell.search = YES;
            cell.imageView.image = nil;
            cell.modelType = PAModelTypeCommitment;
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PAComparisonTableViewSectionCourses) {
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
