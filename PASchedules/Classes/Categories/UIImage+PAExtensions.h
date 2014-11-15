//
//  UIImage+TEExtensions.h
//  TextExchange
//
//  Created by Rudd Fawcett on 10/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PAExtensions)

+ (instancetype)maskedImage:(UIImage *)image color:(UIColor *)color;
+ (instancetype)maskedImageWithName:(NSString *)name color:(UIColor *)color;

@end
