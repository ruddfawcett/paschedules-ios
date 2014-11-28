//
//  PAPeriod.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAPeriod.h"

#import "PASection.h"

@implementation PAPeriod

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        self.section = [[PASection alloc] initWithAttributes:attributes[@"section"]];
        
        self.start = attributes[@"times"][@"start"];
        self.end = attributes[@"times"][@"end"];
        self.teacherName = attributes[@"section"][@"teacher"];
        self.room = attributes[@"room"];
        self.period = attributes[@"period"];
        self.name = attributes[@"section"] ? attributes[@"section"][@"name"] : attributes[@"name"];
        
        if ([self.name isEqualToString:@"Conference"]) {
            self.specialPeriodType = PASpecialPeriodTypeConference;
            self.conference = YES;
        }
        
        if ([self.name isEqualToString:@"All School Meeting"]) {
            self.specialPeriodType = PASpecialPeriodTypeASM;
            self.allSchoolMeeting = YES;
        }
        
        if ([self.name isEqualToString:@"Departmental Meetings"]) {
            self.specialPeriodType = PASpecialPeriodTypeDepartmentMeeting;
            self.departmentMeetings = YES;
        }
        
        if ([self.name isEqualToString:@"Free"]) {
            self.specialPeriodType = PASpecialPeriodTypeFree;
            self.free = YES;
        }
    }
    
    return self;
}

@end
