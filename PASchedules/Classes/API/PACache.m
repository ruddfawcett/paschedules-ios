//
//  PACacheManager.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/24/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACache.h"

@implementation PACache

+ (instancetype)sharedCache {
    static PACache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [PACache new];
    });
    
    return _sharedCache;
}

@end
