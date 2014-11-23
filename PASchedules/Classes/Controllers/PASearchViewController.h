//
//  PASearchViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/21/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAStudent;
@class PATeacher;
@class PASupercourse;

@class PAStudentTableViewCell;
@class PATeacherTableViewCell;
@class PASupercourseTableViewCell;
@class PATextFieldCell;
@class PAEmptyTableViewCell;

@class PAStudentViewController;
@class PATeacherViewController;
@class PASupercourseViewController;

typedef NS_ENUM(NSUInteger, PASearchTableViewSections) {
    PASearchTableViewSectionsSearchField,
    PASearchTableViewSectionsType
};

@interface PASearchViewController : UITableViewController <UITextFieldDelegate>

@end
