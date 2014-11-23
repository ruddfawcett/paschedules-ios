//
//  PAStudent.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PACourse;
@class PACommitment;

@interface PAStudent : NSObject

#pragma mark - Properties

/**
 *  The name of the student.
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The nickname (the name the student prefers to be called) of the student, if the student has one.
 */
@property (strong, nonatomic) NSString *nickname;
/**
 *  The description for searching.
 */
@property (strong, nonatomic) NSString *search;


/**
 *  The student ID of the student in the database (not blueCard ID).
 */
@property (nonatomic) NSUInteger studentId;
/**
 *  The graduation year of the student.
 */
@property (nonatomic) NSUInteger graduation;


/**
 *  An array of PACourse objects that the student has.
 */
@property (strong, nonatomic) NSArray *courses;
/**
 *  An array of PACommitment objects that the student participates in.
 */
@property (strong, nonatomic) NSArray *commitments;

#pragma mark - Instance Methods

/**
 *  Returns a PAStudent instance from an NSDictionary.
 *
 *  @param attributes The decoded JSON from the API call.
 *
 *  @return A PAStudent instance.
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

/**
 *  A helper method to check if this student is the logged in student.
 *
 *  @return Yes or no.
 */
- (BOOL)isCurrentStudent;

@end
