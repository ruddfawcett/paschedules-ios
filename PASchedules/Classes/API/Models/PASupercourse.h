//
//  PASupercourse.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASection;

@interface PASupercourse : NSObject

#pragma mark - Properties

/**
 *  The title of the supercourse.
 */
@property (strong, nonatomic) NSString *title;
/**
 *  The name of the supercourse.
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The description for searching.
 */
@property (strong, nonatomic) NSString *search;


/**
 *  The supercourse Id.
 */
@property (nonatomic) NSUInteger supercourseId;
/**
 *  The number of sections in a supercourse, only used in search.
 */
@property (nonatomic) NSUInteger sectionCount;


/**
 *  An array of PASection objects in the supercourse.
 */
@property (strong, nonatomic) NSArray *sections;

#pragma mark - Instance Methods

/**
 *  Returns a PASupercourse instance from an NSDictionary.
 *
 *  @param attributes The decoded JSON from the API call.
 *
 *  @return A PASupercourse instance.
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
