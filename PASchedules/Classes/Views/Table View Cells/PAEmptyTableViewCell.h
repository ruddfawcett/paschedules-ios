//
//  PAEmptyTableViewCell.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PAModelType) {
    PAModelTypeCourse,
    PAModelTypeCommitment,
    PAModelTypeStudent,
    PAModelTypeSection,
    PAModelTypeTeacher,
    PAModelTypeSupercourse
};

extern NSString * NSStringFromPAModelType(PAModelType modelType);

@interface PAEmptyTableViewCell : UITableViewCell

@property (nonatomic) PAModelType modelType;

#pragma mark - Class Methods

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
