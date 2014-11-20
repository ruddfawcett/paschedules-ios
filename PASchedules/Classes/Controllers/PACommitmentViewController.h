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

typedef NS_ENUM(NSUInteger, PACommitmentTableViewSections) {
    PACommitmentTableViewSectionSupervisor,
    PACommitmentTableViewSectionInfo,
    PACommitmentTableViewSectionStudents
};

@interface PACommitmentViewController : PATemplateTableViewController

@property (strong, nonatomic) PACommitment *commitment;

- (id)initWithCommitment:(PACommitment *)commitment;

@end
