//
//  PACommitment.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PATeacher;
@class PAStudent;

@interface PACommitment : NSObject

#pragma mark - Properties

/**
 *  The  supervisor of the commitment.
 */
@property (strong, nonatomic) PATeacher *teacher;


/**
 *  The name of the commitment.
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The title of the commitment.
 */
@property (strong, nonatomic) NSString *title;


/**
 *  The id of the commitment.
 */
@property (nonatomic) NSUInteger commitmentId;
/**
 *  The size of the commitment.
 */
@property (nonatomic) NSUInteger size;


/**
 *  An array of PAStudents that participate in the commitment.
 */
@property (strong, nonatomic) NSArray *students;

#pragma mark - Instance Methods

/**
 *  Returns a PATeacher instance from an NSDictionary.
 *
 *  @param attributes The decoded JSON from the API call.
 *
 *  @return A PATeacher instance.
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
