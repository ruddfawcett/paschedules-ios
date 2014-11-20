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
@class PASection;
@class PATeacher;
@class PASupercourse;
@class PACommitment;

@protocol PASessionDelegate <NSObject>

@optional

- (void)sessionDidEnd:(NSDictionary *)result;

@end

@interface PASchedulesAPI : AFHTTPRequestOperationManager

@property (strong, nonatomic) PAStudent *currentStudent;

@property (strong, nonatomic) id<PASessionDelegate> delegate;

+ (instancetype)sharedClient;

- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)logout:(void (^)(BOOL *success))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)students:(NSUInteger)studentId success:(void (^)(PAStudent *student))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)schedules:(NSUInteger)studentId success:(void (^)(PASchedule *schedule))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)sections:(NSUInteger)sectionId success:(void (^)(PASection *section))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)teachers:(NSUInteger)teacherId success:(void (^)(PATeacher *teacher))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)supercourses:(NSUInteger)supercourseId success:(void (^)(PASupercourse *supercourse))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)commitments:(NSUInteger)commitmentId success:(void (^)(PACommitment *commitment))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Helper Methods

+ (PAStudent *)studentFromSession;

+ (void)destroySession;

+ (NSDate *)sessionCreated;

+ (BOOL)currentUser;

@end
