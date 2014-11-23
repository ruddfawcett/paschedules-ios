//
//  PATeacher.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATeacher.h"

#import "PASection.h"

@implementation PATeacher

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.name = attributes[@"name"];
        self.department = attributes[@"department"];
        
        self.search = [NSString stringWithFormat:@"%@ %@",self.name,self.department];
        
        self.teacherId = attributes[@"id"] ? [attributes[@"id"] intValue] : 0;
        
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
