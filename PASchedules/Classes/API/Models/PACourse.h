//
//  PACourse.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACourse : NSObject

#pragma mark - Properties

/**
 *  The name of the section that course represents.
 */
@property (strong, nonatomic) NSString *sectionName;
/**
 *  The teacher name of the section that the course represents.
 */
@property (strong, nonatomic) NSString *teacherName;
/**
 *  The room of the section that the course represents.
 */
@property (strong, nonatomic) NSString *room;


/**
 *  The section id that the course represents.
 */
@property (nonatomic) NSUInteger sectionId;

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
