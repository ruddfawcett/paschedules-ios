//
//  NSArray+PAExtensions.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/25/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "NSArray+PAExtensions.h"

#import "PACourse.h"
#import "PACommitment.h"

@implementation NSArray (PAExtensions)

+ (instancetype)arrayOfCourseIds:(NSArray *)courses {
    NSMutableArray *ids = [@[] mutableCopy];
    
    for (PACourse *course in courses) {
        [ids addObject:@(course.sectionId)];
    }
    
    return ids;
}

+ (instancetype)arrayOfCommitmentIds:(NSArray *)commitments {
    NSMutableArray *ids = [@[] mutableCopy];
    
    for (PACommitment *commitment in commitments) {
        [ids addObject:@(commitment.commitmentId)];
    }
    
    return ids;
}

+ (instancetype)arrayOfTeacherNames:(NSArray *)courses {
    NSMutableArray *names = [@[] mutableCopy];
    
    for (PACourse *course in courses) {
        if (!course.teacherName) continue;
        
        [names addObject:course.teacherName];
    }
    
    return names;
}

@end
