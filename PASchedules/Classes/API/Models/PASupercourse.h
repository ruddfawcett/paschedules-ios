//
//  PASupercourse.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASection;

@interface PASupercourse : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *name;

@property (nonatomic) NSUInteger supercourseId;

@property (strong, nonatomic) NSArray *sections;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
