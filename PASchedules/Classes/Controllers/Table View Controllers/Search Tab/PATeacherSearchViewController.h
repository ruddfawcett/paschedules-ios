//
//  PATeacherSearchViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/23/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATemplateTableViewController.h"

@class PATeacher;

@class PATextFieldCell;
@class PAEmptyTableViewCell;
@class PATeacherTableViewCell;

@class PATeacherViewController;

typedef NS_ENUM(NSUInteger, PATeacherSearchTableViewSections) {
    PATeacherSearchTableViewSectionSearch,
    PATeacherSearchTableViewSectionTeachers
};

@interface PATeacherSearchViewController : PATemplateTableViewController

@end
