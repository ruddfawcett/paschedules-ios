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

@property (strong, nonatomic) PAStudent *student;

- (id)initWithStudent:(PAStudent *)student;

@end
