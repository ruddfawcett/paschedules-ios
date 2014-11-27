//
//  PAStudentViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PATemplateTableViewController.h"

@class PAStudent;
@class PACourse;
@class PACommitment;
@class PASection;

@class PAEmptyTableViewCell;
@class PABasicInfoTableViewCell;
@class PACourseTableViewCell;
@class PACommitmentTableViewCell;

@class PASectionViewController;
@class PACommitmentViewController;

typedef NS_ENUM(NSUInteger, PAStudentTableViewSections) {
    PAStudentTableViewSectionInfo,
    PAStudentTableViewSectionCourses,
    PAStudentTableViewSectionCommitments,
};

@interface PAStudentViewController : PATemplateTableViewController

#pragma mark - Properties

/**
 *  The PAStudent the controller represents.
 */
@property (strong, nonatomic) PAStudent *student;

#pragma mark - Instance Methods

/**
 *  Returns this controller with a passed student.
 *
 *  @param commitment A PAStudent.
 *
 *  @return This controller.
 */
- (id)initWithStudent:(PAStudent *)student;

@end
