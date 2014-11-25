//
//  PAEmptyTableViewCell.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAEmptyTableViewCell.h"

NSString * NSStringFromPAModelType(PAModelType modelType) {
    switch (modelType) {
        case PAModelTypeCourse:
            return @"Course";
        case PAModelTypeCommitment:
            return @"Commitment";
        case PAModelTypeStudent:
            return @"Student";
        case PAModelTypeSection:
            return @"Section";
        case PAModelTypeTeacher:
            return @"Teacher";
        case PAModelTypeSupercourse:
            return @"Supercourse";
        default:
            return nil;
    }
}

@implementation PAEmptyTableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self.class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.imageView.image = [UIImage maskedImageWithName:@"warning-sign" color:[UIColor lightGrayColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setModelType:(PAModelType)modelType {
    NSString *type = [NSStringFromPAModelType(modelType) lowercaseString];
    type = [type stringByReplacingOccurrencesOfString:@"super" withString:@""];
    
    self.textLabel.text = self.search ? [NSString stringWithFormat:@"No %@s found.", type] : [NSString stringWithFormat:@"No %@s.", type];
}

@end
