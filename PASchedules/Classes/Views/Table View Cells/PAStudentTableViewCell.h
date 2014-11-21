//
//  PAStudentTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAStudent;

@interface PAStudentTableViewCell : UITableViewCell

@property (strong, nonatomic) PAStudent *student;

#pragma mark - Class Methods

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
