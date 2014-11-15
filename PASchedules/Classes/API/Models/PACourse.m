//
//  PACourse.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACourse.h"

@implementation PACourse

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.sectionName = attributes[@"section"][@"name"];
        self.sectionId = (NSUInteger)attributes[@"section"][@"id"];
        self.teacherName = attributes[@"section"][@"teacher"] != nil ? attributes[@"section"][@"teacher"] : nil;
        self.room = attributes[@"room"];
    }
    
    return self;
}

@end
