//
//  NSError+PAExtensions.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/13/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "NSError+PAExtensions.h"

@implementation PAError

+ (instancetype)sharedError {
    static PAError *_sharedError = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedError = [self new];
    });
    
    return _sharedError;
}

- (void)showWithError:(NSError *)error {
    if (error.code != 666) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionDidEnd:)]) {
                [self.delegate didShowError:error];
            }
        });
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}

@end
