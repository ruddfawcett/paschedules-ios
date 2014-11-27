//
//  PATeacherTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/21/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PATeacher;

@interface PATeacherTableViewCell : UITableViewCell

/**
 *  The PATeacher object assigned to the cell.
 */
@property (strong, nonatomic) PATeacher *teacher;

#pragma mark - Class Methods

/**
 *  Returns a cell
 *
 *  @param reuseIdentifier The cell reuse identiifer.
 *
 *  @return A UITableViewCell.
 */
+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
