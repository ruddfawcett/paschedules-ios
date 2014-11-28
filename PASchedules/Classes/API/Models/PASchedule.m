//
//  PASchedule.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASchedule.h"

#import "PADay.h"

@implementation PASchedule

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        [self loadDays:attributes[@"schedule"]];
    }
    
    return self;
}

- (void)loadDays:(NSArray *)dayList {
    NSMutableArray *theDays = [NSMutableArray array];
    
    int i = 0;
    for (NSArray *day in dayList) {
        PADay *aDay = [[PADay alloc] initWithAttributes:day andIndex:i];
        
        [theDays addObject:aDay];
        
        i++;
    }
    
    self.days = theDays;
}

@end
