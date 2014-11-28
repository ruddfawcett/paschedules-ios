//
//  PADay.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PADay.h"

#import "PAPeriod.h"

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
