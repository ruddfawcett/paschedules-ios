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

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *nickname;


@property (nonatomic) NSUInteger studentId;
@property (nonatomic) NSUInteger graduation;

@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) NSArray *commitments;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
