//
//  PACourse.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/8/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACourse : NSObject

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSString *room;

@property (nonatomic) NSUInteger sectionId;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
