//
//  PACompareViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PAStudentSearchViewController.h"

@class PAStudent;

@class PAStudentViewController;
@class PAComparisonViewController;

typedef NS_ENUM(NSUInteger, PACompareTableViewSections) {
    PACompareTableViewSectionStudents,
    PACompareTableViewSectionCompare
};

@interface PACompareViewController : UITableViewController <PAStudentSearchDelegate>

@end
