//
//  NSDate+PAExtensions.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/19/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PAExtensions)

/**
 *  If the current session date has expired.
 *
 *  @param date The date the session started
 *
 *  @return BOOL of whether it expired (after a week).
 */
+ (BOOL)isExpired:(NSDate *)date;

@end
