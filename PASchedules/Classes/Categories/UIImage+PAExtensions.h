//
//  UIImage+TEExtensions.h
//  TextExchange
//
//  Created by Rudd Fawcett on 10/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PAExtensions)

/**
 *  Returns a masked image with the color provided.
 *
 *  @param image The iage.
 *  @param color The color
 *
 *  @return The masked image.
 */
+ (instancetype)maskedImage:(UIImage *)image color:(UIColor *)color;

/**
 *  Same as maskedImage:color:, but takes imageName for convenience.
 *
 *  @param name  The imageName.
 *  @param color The color
 *
 *  @return The masked image.
 */
+ (instancetype)maskedImageWithName:(NSString *)name color:(UIColor *)color;

/**
 *  Creates an image 1x1 with the background of the given color.
 *
 *  @param color The color of the image.
 *
 *  @return A UIImage.
 */
+ (instancetype)imageWithColor:(UIColor *)color;

@end
