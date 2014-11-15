//
//  PASession.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/11/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASession.h"

#import "PASchedulesAPI.h"

@interface PASession ()

@property (strong, nonatomic) NSString *studentPassword;

@end

@implementation PASession

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.key = attributes[@"result"][@"key"];
        self.studentEmail = attributes[@"parameters"][@"email"];
        self.studentPassword = attributes[@"parameters"][@"password"];
        
        self.studentId = (NSUInteger)attributes[@"result"][@"id"];
    }
    
    return self;
}

- (void)loggedIn:(NSDictionary *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentUser:didLogin:)]) {
            [self.delegate currentUser:self didLogin:result];
        }
    });
}

- (void)logout {
    [[PASchedulesAPI sharedClient] logout:^(BOOL *success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentUser:didLogout:)]) {
                    [self.delegate currentUser:self didLogout:YES];
                }
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(currentUser:didLogout:)]) {
                [self.delegate currentUser:self didLogout:NO];
            }
        });
    }];
}

- (void)sessionEnded:(NSDictionary *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentUser:didEnd:)]) {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            
            [self.delegate currentUser:self didEnd:YES];
        }
    });
}

@end
