//
//  PACommitment.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACommitment.h"

#import "PATeacher.h"
#import "PAStudent.h"

@implementation PACommitment

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.teacher = [[PATeacher alloc] initWithAttributes:attributes[@"teacher"]];
        self.name = attributes[@"name"];
        self.title = attributes[@"title"];
        
        self.commitmentId = attributes[@"id"] ? [attributes[@"id"] intValue] : 0;
        self.size = attributes[@"size"] ? [attributes[@"size"] intValue] : 0;
        
        [self loadStudents:attributes[@"students"]];
    }
    
    return self;
}

- (void)loadStudents:(NSArray *)studentList {
    NSMutableArray *theStudents = [NSMutableArray array];
    
    for (NSDictionary *student in studentList) {
        PAStudent *aStudent = [[PAStudent alloc] initWithAttributes:student];
        
        [theStudents addObject:aStudent];
    }
    
    self.students = theStudents;
}

@end
