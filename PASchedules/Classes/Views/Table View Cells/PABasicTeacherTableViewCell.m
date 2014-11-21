//
//  PABasicTeacherTableViewCell.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PABasicTeacherTableViewCell.h"

#import "PATeacher.h"

@implementation PABasicTeacherTableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self.class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    
    return self;
}

- (void)setTeacher:(PATeacher *)teacher {
    self.accessoryType = teacher.teacherId ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.userInteractionEnabled = teacher.name ? YES : NO;
    self.textLabel.text = (![teacher.name isKindOfClass:[NSNull class]]) ? teacher.name : @"Not available.";
    self.textLabel.textColor = teacher.name ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.selectionStyle = teacher.teacherId ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
}

@end
