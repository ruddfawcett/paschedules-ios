//
//  PACacheManager.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/24/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACache : NSObject

@property (strong, nonatomic) NSArray *students;
@property (strong, nonatomic) NSArray *teachers;
@property (strong, nonatomic) NSArray *supercourses;

@property (nonatomic) BOOL hasBeenUpdated;

#pragma mark - Singleton

/**
 *  A PACache singleton.
 *
 *  @return Returns a PACache.
 */
+ (instancetype)sharedCache;

@end
