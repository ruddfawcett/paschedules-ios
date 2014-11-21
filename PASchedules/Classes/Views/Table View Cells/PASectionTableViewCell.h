//
//  PASectionTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PASection;

@interface PASectionTableViewCell : UITableViewCell

@property (strong, nonatomic) PASection *section;

#pragma mark - Class Methods

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
