//
//  Mixpanel+PAExtensions.m
//  PASchedules
//
//  Created by Rudd Fawcett on 12/3/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "Mixpanel+PAExtensions.h"

@implementation Mixpanel (PAExtensions)

+ (void)track:(NSString *)event {
    [Mixpanel updateLastSeen];
    [[Mixpanel sharedInstance] track:event];
}

+ (void)track:(NSString *)event properties:(NSDictionary *)properties {
    [Mixpanel updateLastSeen];
    [[Mixpanel sharedInstance] track:event properties:properties];
}

+ (void)identifyStudent:(PAStudent *)student {
    [[Mixpanel sharedInstance] identify:[NSString stringWithFormat:@"%lu",(unsigned long)student.studentId]];
    [Mixpanel updateLastSeen];
}

+ (void)updateStudent:(PAStudent *)student {
    [Mixpanel identifyStudent:student];
    
    [[[Mixpanel sharedInstance] people] set:@{
                                              @"$email" : [PASchedulesAPI currentUserEmail] != nil ? [PASchedulesAPI currentUserEmail] : @"",
                                              @"name" : student.name,
                                              @"nickname" : student.nickname ? student.nickname : @"",
                                              @"graduation" : @(student.graduation),
                                              @"id" : @(student.studentId)
                                              }];
}

+ (void)updateLastSeen {
    [[[Mixpanel sharedInstance] people] set:@{@"$last_seen" : [NSDate date]}];
}

@end
