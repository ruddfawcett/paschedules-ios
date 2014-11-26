//
//  PAComparisonViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/24/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATemplateTableViewController.h"

@class PATeacher;
@class PAStudent;
@class PACourse;
@class PACommitment;

@class PAEmptyTableViewCell;
@class PACourseTableViewCell;
@class PATeacherTableViewCell;
@class PACommitmentTableViewCell;

@class PASectionViewController;
@class PATeacherViewController;
@class PACommitmentViewController;

typedef NS_ENUM(NSUInteger, PAComparisonTableViewSections) {
    PAComparisonTableViewSectionCourses,
    PAComparisonTableViewSectionTeachers,
    PAComparisonTableViewSectionCommitments
};

@interface PAComparisonViewController : UITableViewController

- (id)initWithStudent:(PAStudent *)firstStudent andStudent:(PAStudent *)secondStudent;

@end
