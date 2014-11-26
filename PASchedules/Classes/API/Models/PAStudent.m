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
        self.name = attributes[@"name"] ? attributes[@"name"] : nil;
        self.nickname = attributes[@"nickname"] ? attributes[@"nickname"] : nil;
        
        self.studentId = attributes[@"id"] ? [attributes[@"id"] intValue] : 0;
        
        self.graduation = attributes[@"id"] ? [attributes[@"graduation"] intValue] : 0;
        
        NSArray *names = [self.name componentsSeparatedByString:@" "];
        
        self.search = [NSString stringWithFormat:@"%@ %@ %@ %lu %@ %lu %@ %lu %@",names[0],[names lastObject],self.nickname,(unsigned long)self.graduation,names[0],(unsigned long)self.graduation,self.nickname,(unsigned long)self.graduation,[names lastObject]];
        
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

- (BOOL)isCurrentStudent {
    return self.studentId == [PASchedulesAPI sharedClient].currentStudent.studentId;
}

@end
