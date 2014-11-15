//
//  PASchedulesAPI.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASchedulesAPI.h"

#import "PAStudent.h"
#import "PASchedule.h"
#import "PASession.h"

static NSString * const PASchedulesAPIBaseURLString = @"http://paschedulesapi.herokuapp.com/";

@interface PASchedulesAPI ()

@end

@implementation PASchedulesAPI

+ (instancetype)sharedClient {
    static PASchedulesAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PASchedulesAPI alloc] initWithBaseURL:[NSURL URLWithString:PASchedulesAPIBaseURLString]];
    });
    
    return _sharedClient;
}


- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *paramters = @{@"email" : email, @"password" : password};
    
    [self POST:@"api/v1/login/" parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        NSLog(@"%@",result);
        
        if (!result[@"session"]) {
            if ([[NSNumber numberWithBool:(BOOL)result[@"result"]] intValue] == 1) {
                self.currentUser = [[PASession alloc] initWithAttributes:@{@"parameters" : paramters, @"result" : result}];
                
                [self.currentUser loggedIn:result];
                
                success(result);
                return;
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"]}];
                
                failure(nil, error);
            }
        }
        else [self.currentUser sessionEnded:result];
    } failure:failure];
}

- (void)logout:(void (^)(BOOL *success))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self POST:@"api/v1/logout/" parameters:@{@"key" : self.currentUser.key} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([[NSNumber numberWithBool:(BOOL)result[@"result"]] intValue] != 0) {
                BOOL result = YES;
                
                success(&result);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"]}];
                
                failure(nil, error);
            }
        }
        else [self.currentUser sessionEnded:result];
    } failure:failure];
}

- (void)students:(NSUInteger)studentId success:(void (^)(PAStudent *student))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : self.currentUser.key, @"id" : @(studentId)};
    
    [self POST:@"api/v1/students/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([[NSNumber numberWithBool:(BOOL)result[@"result"]] intValue] != 0) {
                PAStudent *student = [[PAStudent alloc] initWithAttributes:result];
                
                success(student);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"]}];
                
                failure(nil, error);
            }
        }
        else [self.currentUser sessionEnded:result];
    } failure:failure];
}

- (void)schedules:(NSUInteger)studentId success:(void (^)(PASchedule *schedule))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : self.currentUser.key, @"id" : @(studentId)};
    
    [self POST:@"api/v1/schedules/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([[NSNumber numberWithBool:(BOOL)result[@"result"]] intValue] != 0) {
                PASchedule *schedule = [[PASchedule alloc] initWithAttributes:result];
                
                success(schedule);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"]}];
                
                failure(nil, error);
            }
        }
        else [self.currentUser sessionEnded:result];
    } failure:failure];
}

@end
