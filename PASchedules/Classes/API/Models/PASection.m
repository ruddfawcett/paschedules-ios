//
//  PASection.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASection.h"

#import "PASupercourse.h"
#import "PATeacher.h"
#import "PAStudent.h"

@implementation PASection

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.name = attributes[@"name"];
        self.period = attributes[@"period"];
        
        self.sectionId = attributes[@"id"] ? [attributes[@"id"] intValue] : 0;
        self.size = attributes[@"size"] ? [attributes[@"size"] intValue] : 0;
        
        if (attributes[@"supercourse"] != nil) {
            [self loadSupercourse:attributes[@"supercourse"]];
        }
        
        [self loadTeacher:attributes[@"teacher"]];
        [self loadStudents:attributes[@"students"]];
    }
    
    return self;
}

- (void)loadSupercourse:(NSDictionary *)supercourseInfo {
    NSDictionary *properFormat = @{@"course" : supercourseInfo};
    PASupercourse *theSupercourse = [[PASupercourse alloc] initWithAttributes:properFormat];
    
    self.supercourse = theSupercourse;
}

- (void)loadTeacher:(NSDictionary *)teacherInfo {
    PATeacher *theTeacher = [[PATeacher alloc] initWithAttributes:teacherInfo];
    
    self.teacher = theTeacher;
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
