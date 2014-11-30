//
//  PADay.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PADay.h"

#import "PAPeriod.h"

NSString * NSStringFromPADayType(PADayType dayType) {
    switch (dayType) {
        case PADayTypeMonday:
            return @"Monday";
            break;
        case PADayTypeTuesday:
            return @"Tuesday";
            break;
        case PADayTypeWednesday:
            return @"Wednesday";
            break;
        case PADayTypeThursday:
            return @"Thursday";
            break;
        default:
            return @"Friday";
            break;
    }
}

@implementation PADay

- (id)initWithAttributes:(NSArray *)attributes andIndex:(NSUInteger)index {
    if (self = [super init]) {
        self.day = index;
        
        [self loadPeriods:attributes];
    }

    return self;
}

- (void)loadPeriods:(NSArray *)periodList {
    NSMutableArray *thePeriods = [NSMutableArray array];
    
    for (NSDictionary *period in periodList) {
        PAPeriod *aPeriod = [[PAPeriod alloc] initWithAttributes:period];
        
        [thePeriods addObject:aPeriod];
    }
    
    self.periods = thePeriods;
}

@end
