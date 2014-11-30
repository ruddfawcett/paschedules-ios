//
//  PATabBarController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/14/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATabBarController.h"

#import "PANavigationController.h"

#import "PAStudentViewController.h"
#import "PACompareViewController.h"
#import "PASearchViewController.h"
#import "PASettingsViewController.h"

@implementation PATabBarController

- (id)initWithStudent:(PAStudent *)student {
    if (self = [super init]) {
        self.tabBar.translucent = NO;
        
        self.student = student;
        [self initialize];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initialize {
    NSMutableArray *viewControllers = [@[] mutableCopy];
    
    PAStudentViewController *studentViewController = [[PAStudentViewController alloc] initWithStudent:self.student];
    studentViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Students" imageName:@"grad-hat-icon" selectedImageName:@"grad-hat-icon-selected"];
    
    [viewControllers addObject:studentViewController];
    
    PACompareViewController *compareViewController = [[PACompareViewController alloc] init];
    compareViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Compare" imageName:@"scale-icon" selectedImageName:@"scale-icon-selected"];
    
    [viewControllers addObject:compareViewController];
    
    UIViewController *scheduleViewController = [[UIViewController alloc] init];
    scheduleViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Schedule" imageName:@"calendar-icon" selectedImageName:@"calendar-icon-selected"];
    
    [viewControllers addObject:scheduleViewController];
    
    PASearchViewController *searchViewController = [[PASearchViewController alloc] init];
    searchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" imageName:@"search-icon" selectedImageName:@"search-icon-selected"];
    
    [viewControllers addObject:searchViewController];
    
    PASettingsViewController *settingsController = [[PASettingsViewController alloc] init];
    settingsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" imageName:@"gear-icon" selectedImageName:@"gear-icon-selected"];
    
    [viewControllers addObject:settingsController];
    
    NSMutableArray *newControllers = [@[] mutableCopy];
    
    for (id eachController in viewControllers) {
        PANavigationController *navController = [[PANavigationController alloc] initWithRootViewController:eachController];
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:kPASchedulesLaunchCount] >= 5) {
            navController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        }
        
        [newControllers addObject:navController];
    }
    
    [self setViewControllers:newControllers];
}

@end
