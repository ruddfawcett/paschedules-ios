//
//  NSArray+PAExtensions.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/25/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PACourse;
@class PACommitment;

@interface NSArray (PAExtensions)

#pragma mark - Convenience Methods

/**
 *  An array of courseIds given an array of courses.
 *
 *  @param courses An array of PACourse Objects.
 *
 *  @return An array of just the courseIds.
 */
+ (instancetype)arrayOfCourseIds:(NSArray *)courses;

/**
 *  An array of commitmentIds given an array of commitments.
 *
 *  @param commitments An array of PACommitment objects.
 *
 *  @return An array of just the commitmentIds.
 */
+ (instancetype)arrayOfCommitmentIds:(NSArray *)commitments;

/**
 *  An array of teacherNames given an array of courrses.
 *
 *  @param names An array of PACourse objects.
 *
 *  @return An array of just the teacher names.
 */
+ (instancetype)arrayOfTeacherNames:(NSArray *)names;

@end
