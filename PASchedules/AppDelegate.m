//
//  AppDelegate.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/7/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "AppDelegate.h"

#import "PASchedulesAPI.h"
#import "PANavigationController.h"
#import "PALoginViewController.h"
#import "PATabBarController.h"
#import "PAStudentViewController.h"

NSString * const kPASchedulesErrorDomain = @"com.ruddfawcett.paschedules.error";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = PA_WHITE;
    
    [[UINavigationBar appearance] setBarTintColor:PA_BLUE];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UITabBar appearance] setTintColor:PA_BLUE];
    
    [[UIToolbar appearance] setBarTintColor:PA_BLUE];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    
    if ([NSDate isExpired:[PASchedulesAPI sessionCreated]] || ![PASchedulesAPI currentUser]) {
        PANavigationController *navController = [[PANavigationController alloc] initWithRootViewController:[PALoginViewController new]];
        
        self.window.rootViewController = navController;
    }
    else {
        PATabBarController *studentController = [[PATabBarController alloc] initWithStudent:[PASchedulesAPI studentFromSession]];
        self.window.rootViewController = studentController;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
