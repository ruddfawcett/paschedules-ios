//
//  NSError+PAExtensions.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/13/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "NSError+PAExtensions.h"

@implementation NSError (PAExtensions)

+ (void)showHUDWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

+ (void)showWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    
    [alert show];
}

@end
