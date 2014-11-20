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
    
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:PA_DARK_BLUE];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
//    [[UITabBar appearance] setBarTintColor:PA_DARK_BLUE];
    [[UITabBar appearance] setTintColor:PA_DARK_BLUE];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
