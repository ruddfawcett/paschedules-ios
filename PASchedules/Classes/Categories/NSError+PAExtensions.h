//
//  NSError+PAExtensions.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/13/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (PAExtensions)

/**
 *  Shows a SVProgressHUD with the localizedDescription of the error passed.
 *
 *  @param error The error.
 */
+ (void)showWithError:(NSError *)error;

@end
