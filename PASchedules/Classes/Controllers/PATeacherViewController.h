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

@property (strong, nonatomic) PATeacher *teacher;

- (id)initWithTeacher:(PATeacher *)teacher;

@end