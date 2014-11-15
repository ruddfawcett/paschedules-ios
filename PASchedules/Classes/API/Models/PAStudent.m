//
//  PAStudent.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAStudent.h"

#import "PACourse.h"
#import "PACommitment.h"

@implementation PAStudent

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.name = attributes[@"name"];
        self.nickname = attributes[@"nickname"] != nil ? attributes[@"nickname"] : nil;
        
        self.studentId = (NSUInteger)attributes[@"id"];
        self.graduation = (NSUInteger)attributes[@"graduation"];
        
        [self loadCourses:attributes[@"courses"]];
        [self loadCommitments:attributes[@"commitments"]];
    }
    
    return self;
}

- (void)loadCourses:(NSArray *)courseList {
    NSMutableArray *theCourses = [NSMutableArray array];
    
    for (NSDictionary *course in courseList) {
        PACourse *aCourse = [[PACourse alloc] initWithAttributes:course];
        
        [theCourses addObject:aCourse];
    }
    
    self.courses = theCourses;
}

- (void)loadCommitments:(NSArray *)commitmentList {
    NSMutableArray *theCommitments = [NSMutableArray array];
    
    for (NSDictionary *commitment in commitmentList) {
        PACommitment *aCourse = [[PACommitment alloc] initWithAttributes:commitment];
        
        [theCommitments addObject:aCourse];
    }
    
    self.commitments = theCommitments;
}

@end
