//
//  PASupercourseViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PATemplateTableViewController.h"

@class PASection;
@class PASupercourse;
@class PATeacher;

@class PABasicInfoTableViewCell;
@class PAEmptyTableViewCell;
@class PASectionTableViewCell;

typedef NS_ENUM(NSUInteger, PASupercourseTableViewSections) {
    PASupercourseTableViewSectionInfo,
    PASupercourseTableViewSectionSections
};

@interface PASupercourseViewController : PATemplateTableViewController

#pragma mark - Properties

/**
 *  The PASupercourse this controller represents.
 */
@property (strong, nonatomic) PASupercourse *supercourse;

#pragma mark - Instance Methods

/**
 *  Returns this controller with a passed supercourse.
 *
 *  @param supercourse A PASupercourse.
 *
 *  @return This controller.
 */
- (id)initWithSupercourse:(PASupercourse *)supercourse;

@end
