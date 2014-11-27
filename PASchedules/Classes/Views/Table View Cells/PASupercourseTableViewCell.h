//
//  PASupercourseTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/21/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PASupercourse;

@interface PASupercourseTableViewCell : UITableViewCell

/**
 *  The PASupercourse object assigned to the cell.
 */
@property (strong, nonatomic) PASupercourse *supercourse;

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
