//
//  PASession.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/11/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASchedulesAPI;
@class PASession;

@protocol PASessionDelegate <NSObject>

@optional

- (void)currentUser:(PASession *)session didLogin:(NSDictionary *)result;
- (void)currentUser:(PASession *)session didLogout:(BOOL)logout;
- (void)currentUser:(PASession *)session didEnd:(BOOL)ended;

@end

@interface PASession : NSObject

@property (strong, nonatomic) id<PASessionDelegate> delegate;

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *studentEmail;

@property (nonatomic) NSUInteger studentId;

- (id)initWithAttributes:(NSDictionary *)attributes;

- (void)loggedIn:(NSDictionary *)result;

- (void)logout;
- (void)sessionEnded:(NSDictionary *)result;

@end
