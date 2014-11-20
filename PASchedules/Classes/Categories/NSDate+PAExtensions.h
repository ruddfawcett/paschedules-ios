//
//  NSDate+PAExtensions.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PAExtensions)

+ (BOOL)isExpired:(NSDate *)date;

@end
