//
//  PATabBarController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/14/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PANavigationController;
@class PAStudentViewController;

@interface PATabBarController : UITabBarController

#pragma mark - Properties

/**
 *  The PAStudent of the current user.
 */
@property (strong, nonatomic) PAStudent *student;

#pragma mark - Instance Methods

/**
 *  Returns this tab bar controller.
 *
 *  @param student The passed student, which helps pass along to PAStudentViewController.
 *
 *  @return Ths tab bar controller.
 */
- (id)initWithStudent:(PAStudent *)student;

@end
