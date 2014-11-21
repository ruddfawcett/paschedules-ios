//
//  PABasicInfoTableViewCell.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PABasicInfoTableViewCell.h"

@implementation PABasicInfoTableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier andText:(NSString *)text andInfo:(id)info {
    return [[self.class alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier andText:text andInfo:info];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andText:(NSString *)text andInfo:(id)info {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.text = text == nil ? @"Not available." : text;
        self.imageView.image = text == nil ? [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]] : nil;
        
        NSString *detailTextReference;
        
        if ([info isKindOfClass:[NSNumber class]]) {
            detailTextReference = @"%d";
        }
        else if ([info isKindOfClass:[NSString class]]) {
            detailTextReference = @"%@";
        }
        
        if ([info isKindOfClass:[NSNumber class]]) {
            self.detailTextLabel.text = [NSString stringWithFormat:detailTextReference, [info intValue]];
        }
        else self.detailTextLabel.text = [NSString stringWithFormat:detailTextReference, info];
    }
    
    return self;
}

@end
