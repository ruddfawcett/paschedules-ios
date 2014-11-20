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

typedef NS_ENUM(NSUInteger, PASupercourseTableViewSections) {
    PASupercourseTableViewSectionInfo,
    PASupercourseTableViewSectionSections
};

@interface PASupercourseViewController : PATemplateTableViewController

@property (strong, nonatomic) PASupercourse *supercourse;

- (id)initWithSupercourse:(PASupercourse *)supercourse;

@end
