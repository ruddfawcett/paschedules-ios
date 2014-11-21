//
//  PACommitmentViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PATemplateTableViewController.h"

@class PACommitment;
@class PAStudent;

@class PABasicTeacherTableViewCell;
@class PABasicInfoTableViewCell;
@class PAEmptyTableViewCell;
@class PAStudentTableViewCell;

typedef NS_ENUM(NSUInteger, PACommitmentTableViewSections) {
    PACommitmentTableViewSectionSupervisor,
    PACommitmentTableViewSectionInfo,
    PACommitmentTableViewSectionStudents
};

@interface PACommitmentViewController : PATemplateTableViewController

#pragma mark - Properties

/**
 *  The commitment that the controller represents.
 */
@property (strong, nonatomic) PACommitment *commitment;

#pragma mark - Instance Methods

/**
 *  Returns this controller with a passed commitment.
 *
 *  @param commitment A PACommitment.
 *
 *  @return This controller.
 */
- (id)initWithCommitment:(PACommitment *)commitment;

@end
