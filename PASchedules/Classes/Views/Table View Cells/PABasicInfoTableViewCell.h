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

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier andText:(NSString *)text andInfo:(id)info;

@end
