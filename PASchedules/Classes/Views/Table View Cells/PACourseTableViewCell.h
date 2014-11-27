//
//  PACourseTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PACourse;

@interface PACourseTableViewCell : UITableViewCell

/**
 *  The PACourse assigned to the cell.
 */
@property (strong, nonatomic) PACourse *course;

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
