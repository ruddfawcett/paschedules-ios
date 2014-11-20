//
//  PATeacher.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/9/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PASection;

@interface PATeacher : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *department;

@property (nonatomic) NSUInteger teacherId;

@property (strong, nonatomic) NSArray *sections;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
