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

/**
 *  Provides a string based on a model type.
 *
 *  @param modelType The PAModelType
 *
 *  @return A string of the model type (e.g. PAModelTypeTeacher --> "Teacher").
 */
extern NSString * NSStringFromPAModelType(PAModelType modelType);

@interface PAEmptyTableViewCell : UITableViewCell

/**
 *  The PAModel type enum, which helps tell the cell what text to display.
 */
@property (nonatomic) PAModelType modelType;

/**
 *  Whether or not the cell is being shown in a search view/view controller.
 */
@property (nonatomic) BOOL search;

#pragma mark - Class Methods

/**
 *  Returns a cell
 *
 *  @param reuseIdentifier The cell reuse identiifer.
 *
 *  @return A UITableViewCell.
 */
+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
