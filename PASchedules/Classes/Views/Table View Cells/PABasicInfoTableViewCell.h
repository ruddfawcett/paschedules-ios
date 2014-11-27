//
//  PABasicInfoTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PABasicInfoTableViewCell : UITableViewCell

#pragma mark - Class Methods

/**
 *  Returns a cell wit UITableViewCellStyleValue1.  An all purpose use cell.
 *
 *  @param reuseIdentifier The reuse identifier for the cell.
 *  @param text            The textLabel text (the text in black on left side).
 *  @param info            The detailTextLable text (the text in light gray on the right side).
 *
 *  @return A cell!
 */
+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier andText:(NSString *)text andInfo:(id)info;

@end
