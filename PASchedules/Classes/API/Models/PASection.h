//
//  PASection.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASupercourse;
@class PATeacher;
@class PAStudent;

@interface PASection : NSObject

@property (strong, nonatomic) PASupercourse *supercourse;

@property (strong, nonatomic) PATeacher *teacher;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *period;

@property (nonatomic) NSUInteger sectionId;
@property (nonatomic) NSUInteger size;

@property (strong, nonatomic) NSArray *students;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
