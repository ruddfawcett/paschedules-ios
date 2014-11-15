//
//  PACommitment.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAStudent;

@interface PACommitment : NSObject

@property (strong, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;

@property (nonatomic) NSUInteger commitmentId;

@property (strong, nonatomic) NSNumber *size;

@property (strong, nonatomic) NSArray *students;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
