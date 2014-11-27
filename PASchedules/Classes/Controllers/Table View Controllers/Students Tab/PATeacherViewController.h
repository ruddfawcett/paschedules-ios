//
//  PATeacherViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PATemplateTableViewController.h"

@class PASection;
@class PAStudent;
@class PASupercourse;
@class PATeacher;

@class PAEmptyTableViewCell;
@class PASectionTableViewCell;

@class PASectionViewController;

typedef NS_ENUM(NSUInteger, PATeacherTableViewSections) {
    PATeacherTableViewSectionInfo,
    PATeacherTableViewSectionSections
};

@interface PATeacherViewController : PATemplateTableViewController

#pragma mark - Properties

/**
 *  The PATeacher that the controller represents.
 */
@property (strong, nonatomic) PATeacher *teacher;

#pragma mark - Instance Methods

/**
 *  Returns this controller with a passed teacher.
 *
 *  @param commitment A PATeacher.
 *
 *  @return This controller.
 */
- (id)initWithTeacher:(PATeacher *)teacher;

@end