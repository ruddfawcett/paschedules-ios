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

+ (instancetype)arrayOfCourseIds:(NSArray *)courses;
+ (instancetype)arrayOfCommitmentIds:(NSArray *)commitments;
+ (instancetype)arrayOfTeacherNames:(NSArray *)names;

@end
