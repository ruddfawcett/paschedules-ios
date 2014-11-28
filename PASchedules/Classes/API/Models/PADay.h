//
//  PADay.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAPeriod;

typedef NS_ENUM(NSUInteger, PADayType) {
    PADayTypeMonday,
    PADayTypeTuesday,
    PADayTypeWednesday,
    PADayTypeThursday,
    PADayTypeFriday
};

NSString * NSStringFromPADayType (PADayType dayType);

@interface PADay : NSObject

@property (nonatomic) PADayType day;

@property (strong, nonatomic) NSArray *periods;

#pragma mark - Instance Methods

/**
 *  Returns a PADay instance from an NSArray.
 *
 *  @param attributes The array of JSON periods.
 *  @param index      The index of the arry in the schedule array.
 *
 *  @return A PADay instance.
 */
- (id)initWithAttributes:(NSArray *)attributes andIndex:(NSUInteger)index;
@end
