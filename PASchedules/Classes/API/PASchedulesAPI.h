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

typedef NS_ENUM(NSUInteger, PAAPIListTypes) {
    PAAPIListTypeStudents,
    PAAPIListTypeTeachers,
    PAAPIListTypeSupercourses
};

NSString * NSStringFromPAAPIListType (PAAPIListTypes type);

#pragma mark - Delegate

@protocol PASessionDelegate <NSObject>

@optional

/**
 *  A delegate that triggers when the current user's session has ended.
 *
 *  @param result The result, so the error can be grabbed as changed on server.
 */
- (void)sessionDidEnd:(NSDictionary *)result;

@end

@interface PASchedulesAPI : AFHTTPRequestOperationManager

/**
 *  A PAStudent instance of the current student logged in.
 */
@property (strong, nonatomic) PAStudent *currentStudent;

/**
 *  A PASessionDelegate.
 */
@property (strong, nonatomic) id<PASessionDelegate> delegate;

#pragma mark - API Methods

/**
 *  Attempts to login a student.
 *
 *  @param email    The email address associated with the student's account.
 *  @param password The password associated with the student's account.
 *  @param success  A block that is triggered if the login is successful.
 *  @param failure  A block that is triggered if the login is not successful.
 */
- (void)login:(NSString *)email withPassword:(NSString *)password success:(void (^)(NSDictionary *result))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Logouts a user, by destroying their sesssion.
 *
 *  @param success A block that is triggered if the logout is successful.
 *  @param failure A block that is triggered if the logout is not successful.
 */
- (void)logout:(void (^)(BOOL *success))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Fetches a student by their student ID (not BlueCard ID).
 *
 *  @param studentId The id of the stuent.
 *  @param success A block that is triggered if the student is successfully grabbed.
 *  @param failure A block that is triggered if the student is not successfully grabbed.
 */
- (void)students:(NSUInteger)studentId success:(void (^)(PAStudent *student))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Fetches a schedule for a student based on their student ID.
 *
 *  @param studentId The ID of the student.
 *  @param success A block that is triggered if the schedule is successfully grabbed.
 *  @param failure A block that is triggered if the schedule is not successfully grabbed.
 */
- (void)schedules:(NSUInteger)studentId success:(void (^)(PASchedule *schedule))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Fetches a section for the given section ID.
 *
 *  @param sectionId The section ID.
 *  @param success A block that is triggered if the section is successfully grabbed.
 *  @param failure A block that is triggered if the section is not successfully grabbed.
 */
- (void)sections:(NSUInteger)sectionId success:(void (^)(PASection *section))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Fetches a teacher for the given teacher ID.
 *
 *  @param teacherId The teacher ID.
 *  @param success A block that is triggered if the teacher is successfully grabbed.
 *  @param failure A block that is triggered if the teacher is not successfully grabbed.
 */
- (void)teachers:(NSUInteger)teacherId success:(void (^)(PATeacher *teacher))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Fetches the supercoure for the given ID.
 *
 *  @param supercourseId The supercourse ID.
 *  @param success A block that is triggered if the supercourse is successfully grabbed.
 *  @param failure A block that is triggered if the supercourse is not successfully grabbed.
 */
- (void)supercourses:(NSUInteger)supercourseId success:(void (^)(PASupercourse *supercourse))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Fetches the commitment for the given ID.
 *
 *  @param commitmentId The commitment ID.
 *  @param success A block that is triggered if the commitment is successfully grabbed.
 *  @param failure A block that is triggered if the commitment is not successfully grabbed.
 */
- (void)commitments:(NSUInteger)commitmentId success:(void (^)(PACommitment *commitment))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Returns the JSON list of objects for searching.
 *
 *  @param listType The list type, e.g. teachers/students/supercourses.
 *  @param success  A block triggered on success.
 *  @param failure  A block triggered on failure.
 */
- (void)list:(PAAPIListTypes)listType success:(void (^)(NSArray *list))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Singleton

/**
 *  A PASchedulesAPI singleton.
 *
 *  @return A PASchedulesAPI object.
 */
+ (instancetype)sharedClient;

#pragma mark - Helper Methods

/**
 *  Destroy the current session for the user.
 */
+ (void)destroySession;

/**
 *  Give me a student from the session!
 *
 *  @return Here.
 */
+ (PAStudent *)studentFromSession;

/**
 *  If there is a current user.
 *
 *  @return If there is a current user.
 */
+ (BOOL)currentUser;

/**
 *  Helper for date of session
 *
 *  @return NSDate, when the session was created.
 */
+ (NSDate *)sessionCreated;

@end
