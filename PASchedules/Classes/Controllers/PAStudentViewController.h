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

@class PASectionViewController;
@class PACommitmentViewController;

typedef NS_ENUM(NSUInteger, PAStudentTableViewSections) {
    PAStudentTableViewSectionInfo,
    PAStudentTableViewSectionCourses,
    PAStudentTableViewSectionCommitments,
};

@interface PAStudentViewController : PATemplateTableViewController

@property (strong, nonatomic) PAStudent *student;

- (id)initWithStudent:(PAStudent *)student;

@end
