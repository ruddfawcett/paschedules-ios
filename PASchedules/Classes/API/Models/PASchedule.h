//
//  PASchedule.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PADay;

@interface PASchedule : NSObject

/**
 *  The owner of the schedule.
 */
@property (strong, nonatomic) PAStudent *student;

/**
 *  An array of PADay objects.
 */
@property (strong, nonatomic) NSArray *days;

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
