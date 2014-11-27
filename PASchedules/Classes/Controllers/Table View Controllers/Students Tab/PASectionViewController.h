//
//  PASectionViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PATemplateTableViewController.h"

@class PASection;
@class PAStudent;
@class PASupercourse;
@class PATeacher;

@class PAEmptyTableViewCell;
@class PABasicInfoTableViewCell;
@class PABasicTeacherTableViewCell;
@class PAStudentTableViewCell;

@class PASupercourseViewController;
@class PATeacherViewController;
@class PAStudentViewController;

typedef NS_ENUM(NSUInteger, PASectionTableViewSections) {
    PASectionTableViewSectionSupercourse,
    PASectionTableViewSectionTeacher,
    PASectionTableViewSectionInfo,
    PASectionTableViewSectionStudents
};

@interface PASectionViewController : PATemplateTableViewController

#pragma mark - Properties

/**
 *  The PASection that the controller represents.
 */
@property (strong, nonatomic) PASection *section;

#pragma mark - Instance Methods
/**
 *  Returns this controller with a passed section.
 *
 *  @param commitment A PASection.
 *
 *  @return This controller.
 */
- (id)initWithSection:(PASection *)section;

@end