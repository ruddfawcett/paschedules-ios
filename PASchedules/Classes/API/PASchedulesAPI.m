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
#import "PASection.h"
#import "PATeacher.h"
#import "PASupercourse.h"
#import "PACommitment.h"

#import "PALoginViewController.h"

#import "Mixpanel+PAExtensions.h"

NSString * NSStringFromPAAPIListType(PAAPIListTypes type) {
    switch (type) {
        case PAAPIListTypeStudents:
            return @"Students";
            break;
        case PAAPIListTypeTeachers:
            return @"Teachers";
            break;
        case PAAPIListTypeSupercourses:
            return @"Supercourses";
            break;
        default:
            return nil;
    }
}

/**
 *  The base URL for the API.
 */
static NSString * const PASchedulesAPIBaseURLString = @"http://paschedulesapi.herokuapp.com/";

@interface PASchedulesAPI ()

/**
 *  A counter that keeps track of the number of times the user has logged in.
 */
@property (nonatomic) NSUInteger loginAttempts;


/**
 *  Whether or not the alert view for the above should be shown.
 */
@property (nonatomic) BOOL showedError;


/**
 *  The user's email.
 */
@property (strong, nonatomic) NSString *currentEmail;

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
    NSDictionary *paramters = @{@"email" : email, @"password" : password, @"ios" : @YES};
    
    [self POST:@"api/v1/login/" parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] == 1) {
                self.currentStudent = [[PAStudent alloc] initWithAttributes:result];
                
                self.currentEmail = email;
                [self saveSession:result[@"key"] forStudent:self.currentStudent];
                
                [Mixpanel track:@"Student Logged In" properties:@{@"attempts" : @(self.loginAttempts+1)}];
                [Mixpanel identifyStudent:self.currentStudent];
                
                success(result);
                return;
            }
            else {
                self.loginAttempts++;
                
                NSError *error;

                if (self.loginAttempts >= 3 && !self.showedError) {
                    error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:666 userInfo:@{NSLocalizedDescriptionKey : @"We've noticed something's up.\n\nIt looks like you've gotten a few failed logins, and we're sorry.\n\nAre you sure you're connected to the internet?\n\nWe're doing our best to lock down this login issue, so please just keep trying!"}];
                    
                    self.showedError = YES;
                }
                else {
                    error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"]}];
                }
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)logout:(void (^)(BOOL *success))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self POST:@"api/v1/logout/" parameters:@{@"key" : [self sessionKey], @"ios" : @YES} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                BOOL successful = YES;
                
                [Mixpanel track:@"Student Logged Out"];
                
                [self sessionEnded:result];
                [PASchedulesAPI destroySession];
                
                success(&successful);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)students:(NSUInteger)studentId track:(BOOL)track success:(void (^)(PAStudent *student))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"id" : @(studentId), @"ios" : @YES};
    
    [self POST:@"api/v1/students/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                PAStudent *student = [[PAStudent alloc] initWithAttributes:result];
                
                if (!student.isCurrentStudent) {
                    if (track) {
                        [Mixpanel track:@"Student Viewed" properties:@{@"Subject Name" : student.name, @"Subject ID": @(student.studentId)}];
                    }
                }
                
                success(student);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)schedules:(NSUInteger)studentId track:(BOOL)track success:(void (^)(PASchedule *schedule))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"id" : @(studentId), @"ios" : @YES};
    
    [self POST:@"api/v1/schedules/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                PASchedule *schedule = [[PASchedule alloc] initWithAttributes:result];
                
                if (track) {
                    [Mixpanel track:@"Schedule Viewed" properties:@{@"Subject Name" : schedule.student.name, @"Subject ID": @(schedule.student.studentId)}];
                }
                
                success(schedule);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)sections:(NSUInteger)sectionId track:(BOOL)track success:(void (^)(PASection *section))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"id" : @(sectionId), @"ios" : @YES};
    
    [self POST:@"api/v1/sections/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                PASection *section = [[PASection alloc] initWithAttributes:result];
                
                if (track) {
                    [Mixpanel track:@"Section Viewed" properties:@{@"Subject Name" : section.name, @"Subject ID": @(section.sectionId)}];
                }
                
                success(section);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)teachers:(NSUInteger)teacherId track:(BOOL)track success:(void (^)(PATeacher *teacher))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"id" : @(teacherId), @"ios" : @YES};
    
    [self POST:@"api/v1/teachers/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                PATeacher *teacher = [[PATeacher alloc] initWithAttributes:result];
                
                if (track) {
                    [Mixpanel track:@"Teacher Viewed" properties:@{@"Subject Name" : teacher.name, @"Subject ID": @(teacher.teacherId)}];
                }
                
                success(teacher);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)supercourses:(NSUInteger)supercourseId track:(BOOL)track success:(void (^)(PASupercourse *supercourse))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"id" : @(supercourseId), @"ios" : @YES};
    
    [self POST:@"api/v1/supercourses/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                PASupercourse *supercourse = [[PASupercourse alloc] initWithAttributes:result];
                
                if (track) {
                    [Mixpanel track:@"Supercourse Viewed" properties:@{@"Subject Name" : supercourse.title, @"Subject ID": @(supercourse.supercourseId)}];
                }
                
                success(supercourse);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)commitments:(NSUInteger)commitmentId track:(BOOL)track success:(void (^)(PACommitment *commitment))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"id" : @(commitmentId), @"ios" : @YES};
    
    [self POST:@"api/v1/commitments/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if (!result[@"session"]) {
            if ([result[@"result"] intValue] != 0 || result[@"result"] == nil) {
                PACommitment *commitment = [[PACommitment alloc] initWithAttributes:result];
                
                if (track) {
                    [Mixpanel track:@"Commitment Viewed" properties:@{@"Subject Name" : commitment.name, @"Subject ID": @(commitment.commitmentId)}];
                }
                
                success(commitment);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : result[@"message"] ? result[@"message"] : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else [self sessionEnded:result];
    } failure:failure];
}

- (void)list:(PAAPIListTypes)listType success:(void (^)(NSArray *list))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"key" : [self sessionKey], @"query" : @"empty", @"type" : [NSStringFromPAAPIListType(listType) lowercaseString], @"ios" : @YES};
    
    [self POST:@"api/v1/search/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *result = (NSArray *)responseObject;
            
            if (listType == PAAPIListTypeStudents) {
                NSMutableArray *studentList = [@[] mutableCopy];
                for (NSDictionary *student in result) {
                    PAStudent *aStudent = [[PAStudent alloc] initWithAttributes:student];
                    [studentList addObject:aStudent];
                }
                
                success(studentList);
            }
            else if (listType == PAAPIListTypeTeachers) {
                NSMutableArray *teacherList = [@[] mutableCopy];
                for (NSDictionary *teacher in result) {
                    PATeacher *aTeacher = [[PATeacher alloc] initWithAttributes:teacher];
                    [teacherList addObject:aTeacher];
                }
                
                success(teacherList);
            }
            else if (listType == PAAPIListTypeSupercourses) {
                NSMutableArray *supercourseList = [@[] mutableCopy];
                for (NSDictionary *supercourse in result) {
                    PASupercourse *aSupercourse = [[PASupercourse alloc] initWithAttributes:supercourse];
                    [supercourseList addObject:aSupercourse];
                }
                
                success(supercourseList);
            }
            else {
                NSError *error = [[NSError alloc] initWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Fetch error. No results."}];
                
                failure(nil, error);
            }
        }
        else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"session"]) {
                    [self sessionEnded:nil];
                }
            }
        }
    } failure:failure];
}

- (void)saveSession:(NSString *)key forStudent:(PAStudent *)student {
    [[NSUserDefaults standardUserDefaults] setObject:@{@"key" : key, @"studentId" : @(student.studentId), @"created" : [NSDate date], @"email" : self.currentEmail ? self.currentEmail : @""} forKey:@"session"];
}

- (NSString *)sessionKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session"][@"key"];
}

+ (PAStudent *)studentFromSession {
    NSUInteger studentId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"session"][@"studentId"] intValue];
    
    return [[PAStudent alloc] initWithAttributes:@{@"id" : @(studentId)}];
}

+ (BOOL)currentUser {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session"] != nil;
}

+ (NSString *)currentUserEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session"][@"email"];
}

+ (void)destroySession {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
}

+ (NSDate *)sessionCreated {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session"][@"created"];
}

- (void)sessionEnded:(NSDictionary *)result {
    [PASchedulesAPI destroySession];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionDidEnd:)]) {
            [self.delegate sessionDidEnd:result];
            
            PANavigationController *navController = [[PANavigationController alloc] initWithRootViewController:[PALoginViewController new]];
            
            [[UIApplication sharedApplication] delegate].window.rootViewController = navController;
        }
    });
}

@end
