//
//  PATeacher.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASection;

@interface PATeacher : NSObject

#pragma mark - Properties

/**
 *  The name of the teacher.
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The department of the teacher.
 */
@property (strong, nonatomic) NSString *department;


/**
 *  The id for the teacher.
 */
@property (nonatomic) NSUInteger teacherId;


/**
 *  An array of PASection objects that the teacher teaches.
 */
@property (strong, nonatomic) NSArray *sections;

#pragma mark - Instance Methods

/**
 *  Returns a PATeacher instance from an NSDictionary.
 *
 *  @param attributes The decoded JSON from the API call.
 *
 *  @return A PATeacher instance.
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
