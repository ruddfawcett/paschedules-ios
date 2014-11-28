//
//  PASection.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASection;

typedef NS_ENUM(NSUInteger, PASpecialPeriodType) {
    PASpecialPeriodTypeASM,
    PASpecialPeriodTypeFree,
    PASpecialPeriodTypeConference,
    PASpecialPeriodTypeDepartmentMeeting
};

NSString * NSStringFromPASpecialPeriodType;

@interface PAPeriod : NSObject

#pragma mark - Properties

@property (strong, nonatomic) PASection *section;

/**
 *  The time the period starts.
 */
@property (strong, nonatomic) NSString *start;
/**
 *  The time the period ends.
 */
@property (strong, nonatomic) NSString *end;
/**
 *  The name of the section for the period.
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The name of the teacher
 */
@property (strong, nonatomic) NSString *teacherName;
/**
 *  Th room of the period.
 */
@property (strong, nonatomic) NSString *room;
/**
 *  The period.
 */
@property (strong, nonatomic) NSString *period;


/**
 *  If/the period special period type.
 */
@property (nonatomic) PASpecialPeriodType specialPeriodType;


/**
 *  If the period is all school meeting.
 */
@property (nonatomic, getter=isASM) BOOL allSchoolMeeting;
/**
 *  If the period is a free or not.
 */
@property (nonatomic, getter=isFree) BOOL free;
/**
 *  If the period is conference or not.
 */
@property (nonatomic, getter=isConference) BOOL conference;
/**
 *  If the period is departmental meetings or not.
 */
@property (nonatomic, getter=isDeepartmentMeetings) BOOL departmentMeetings;

#pragma mark - Instance Methods

/**
 *  Returns a PAPeriod instance from an NSDictionary.
 *
 *  @param attributes The decoded JSON from the API call.
 *
 *  @return A PAPeriod instance.
 */
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
