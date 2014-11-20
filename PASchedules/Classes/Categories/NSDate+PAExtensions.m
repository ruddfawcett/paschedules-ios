//
//  NSDate+PAExtensions.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "NSDate+PAExtensions.h"

@implementation NSDate (PAExtensions)

+ (NSDateFormatter *)sharedFormatter {
    static NSDateFormatter *_sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [[NSDateFormatter alloc] init];
    });
    
    return _sharedFormatter;
}

+ (BOOL)isExpired:(NSDate *)date {
    if (date == nil) return NO;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:date
                                                          toDate:[NSDate date]
                                                         options:0];
    
    if ([components day] >= 7) {
        return YES;
    }
    
    return NO;
}

@end
