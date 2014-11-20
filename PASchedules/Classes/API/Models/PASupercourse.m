//
//  PASupercourse.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASupercourse.h"

#import "PASection.h"

@implementation PASupercourse

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.name = attributes[@"course"][@"class"];
        self.title = attributes[@"course"][@"title"];
        
        self.supercourseId = attributes[@"course"][@"id"] ? [attributes[@"course"][@"id"] intValue] : 0;
        
        [self loadSections:attributes[@"sections"]];
    }
    
    return self;
}

- (void)loadSections:(NSDictionary *)sectionList {
    NSMutableArray *theSections = [NSMutableArray array];
    
    for (NSDictionary *section in sectionList) {
        PASection *aSection = [[PASection alloc] initWithAttributes:section];
        
        [theSections addObject:aSection];
    }
    
    self.sections = theSections;
}

@end
