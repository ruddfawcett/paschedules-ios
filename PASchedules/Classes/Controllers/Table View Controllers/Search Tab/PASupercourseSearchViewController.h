//
//  PASupercourseSearchViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/23/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATemplateTableViewController.h"

@class PASupercourse;

@class PATextFieldCell;
@class PAEmptyTableViewCell;
@class PASupercourseTableViewCell;

@class PASupercourseViewController;

typedef NS_ENUM(NSUInteger, PASupercourseSearchTableViewSections) {
    PASupercourseSearchTableViewSectionSearch,
    PASupercourseSearchTableViewSectionSupercourses
};

@interface PASupercourseSearchViewController : PATemplateTableViewController

@end
