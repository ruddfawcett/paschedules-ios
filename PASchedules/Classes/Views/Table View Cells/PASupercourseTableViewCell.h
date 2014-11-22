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

@property (strong, nonatomic) PASupercourse *supercourse;

#pragma mark - Class Methods

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
