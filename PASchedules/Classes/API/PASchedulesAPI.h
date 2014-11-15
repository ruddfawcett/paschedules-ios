//
//  PASchedulesAPI.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class PAStudent;
@class PASchedule;
@class PASession;

@interface PASchedulesAPI : AFHTTPRequestOperationManager

@property (strong, nonatomic) PASession *currentUser;

+ (instancetype)sharedClient;

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)logout:(void (^)(BOOL *success))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)students:(NSUInteger)studentId success:(void (^)(PAStudent *student))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)schedules:(NSUInteger)studentId success:(void (^)(PASchedule *schedule))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
