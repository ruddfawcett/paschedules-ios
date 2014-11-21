//
//  PASection.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASupercourse;
@class PATeacher;
@class PAStudent;

@interface PASection : NSObject

#pragma mark - Properties

/**
 *  The PASupercourse of the section.
 */
@property (strong, nonatomic) PASupercourse *supercourse;
/**
 *  The PATeacher of the section.
 */
@property (strong, nonatomic) PATeacher *teacher;


/**
 *  The name of the section.
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The period the section is, ex. 5th.
 */
@property (strong, nonatomic) NSString *period;


/**
 *  The id for the section.
 */
@property (nonatomic) NSUInteger sectionId;
/**
 *  The size of the section (how many students in it).
 */
@property (nonatomic) NSUInteger size;


/**
 *  An array of PAStudent that are in the section.
 */
@property (strong, nonatomic) NSArray *students;


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
