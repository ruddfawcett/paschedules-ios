//
//  Crashlytics+PAExtensions.m
//  PASchedules
//
//  Created by Rudd Fawcett on 12/4/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "Crashlytics+PAExtensions.h"

@implementation Crashlytics (PAExtensions)

+ (void)setStudent:(PAStudent *)student {
    [[Crashlytics sharedInstance] setUserEmail:[PASchedulesAPI currentUserEmail] != nil ? [PASchedulesAPI currentUserEmail] : @""];
    [[Crashlytics sharedInstance] setUserIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)student.studentId]];
    [[Crashlytics sharedInstance] setUserName:student.name];
}

@end
