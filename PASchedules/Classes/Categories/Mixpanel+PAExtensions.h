//
//  Mixpanel+PAExtensions.h
//  PASchedules
//
//  Created by Rudd Fawcett on 12/3/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "Mixpanel.h"

@interface Mixpanel (PAExtensions)

+ (void)track:(NSString *)event;
+ (void)track:(NSString *)event properties:(NSDictionary *)properties;

+ (void)identifyStudent:(PAStudent *)student;
+ (void)updateStudent:(PAStudent *)student;

@end
