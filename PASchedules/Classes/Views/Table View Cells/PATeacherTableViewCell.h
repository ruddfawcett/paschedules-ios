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

@property (strong, nonatomic) PATeacher *teacher;

#pragma mark - Class Methods

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
