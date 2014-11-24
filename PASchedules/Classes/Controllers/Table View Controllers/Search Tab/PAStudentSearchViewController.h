//
//  PAStudentSearchViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/23/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PATemplateTableViewController.h"

@class PAStudent;

@class PATextFieldCell;
@class PAEmptyTableViewCell;
@class PAStudentTableViewCell;

@class PAStudentViewController;

typedef NS_ENUM(NSUInteger, PAStudentSearchTableViewSections) {
    PAStudentSearchTableViewSectionSearch,
    PAStudentSearchTableViewSectionStudents
};

@interface PAStudentSearchViewController : PATemplateTableViewController

@end
