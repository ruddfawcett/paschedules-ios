//
//  NSError+PAExtensions.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/13/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAError;

@protocol PAErrorDelegate <NSObject>

/**
 *  Triggered when an error was shown
 *
 *  @param error The error.
 */
- (void)didShowError:(NSError *)error;

@end

@interface PAError : NSError

/**
 *  The delegate.
 */
@property (strong, nonatomic) id<PAErrorDelegate>delegate;

/**
 *  A NSError singleton.
 *
 *  @return Returns a NSError.
 */
+ (instancetype)sharedError;

/**
 *  Shows a SVProgressHUD with the localizedDescription of the error passed.
 *
 *  @param error The error.
 */
- (void)showWithError:(NSError *)error;

@end
