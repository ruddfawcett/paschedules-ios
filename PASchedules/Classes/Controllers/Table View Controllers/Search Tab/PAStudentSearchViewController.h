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

#pragma mark - Delegate

@class PAStudentSearchViewController;

@protocol PAStudentSearchDelegate <NSObject>

@required;

/**
 *  A required method for any controller utilizing the PAStudentSearchDelegate.  Passes the student selected in the search.
 *
 *  @param student   The PAStudent selected.
 *  @param indexPath The indexPath the controller was initialized with.
 */
- (void)studentSelected:(PAStudent *)student forIndexPath:(NSIndexPath *)indexPath;

@end

@interface PAStudentSearchViewController : PATemplateTableViewController

#pragma mark - Properties

/**
 *  The PAStudentSearchDelegate.
 */
@property (strong, nonatomic) id<PAStudentSearchDelegate> delegate;

#pragma mark - Instance Methods

/**
 *  Initializes a search controller with the indexPath (used for hte comparison controller).
 *
 *  @param indexPath The indexPath of the compare cell selected.
 *
 *  @return This controller.
 */
- (id)initWithIndexPath:(NSIndexPath *)indexPath;

@end
