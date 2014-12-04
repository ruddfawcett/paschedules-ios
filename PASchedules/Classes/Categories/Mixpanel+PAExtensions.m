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
    [[Mixpanel sharedInstance] track:event];
}

+ (void)track:(NSString *)event properties:(NSDictionary *)properties {
    [[Mixpanel sharedInstance] track:event properties:properties];
}

+ (void)identifyStudent:(PAStudent *)student {
    [[Mixpanel sharedInstance] identify:[NSString stringWithFormat:@"%lu",(unsigned long)student.studentId]];
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

@end
