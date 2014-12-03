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

NSString * const kPASchedulesFirstLaunch = @"com.ruddfawcett.paschedules.firstLaunch";
NSString * const kPASchedulesLaunchCount = @"com.ruddfawcett.paschedules.launchCount";
NSString * const kPASchedulesErrorDomain = @"com.ruddfawcett.paschedules.error";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (PASchedulesKeys *)keys {
    static PASchedulesKeys *_sharedKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedKeys = PASchedulesKeys.new;
    });
    
    return _sharedKeys;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PASchedulesKeys *keys = PASchedulesKeys.new;
    
    [Crashlytics startWithAPIKey:keys.crashlyticsKey];
    [Mixpanel sharedInstanceWithToken:keys.mixpanelToken];
    
    [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"Opened on %@ at %@.",kDeviceName,[NSDate date]]];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = PA_WHITE;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kPASchedulesFirstLaunch]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:kPASchedulesLaunchCount]+1 forKey:kPASchedulesLaunchCount];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPASchedulesFirstLaunch];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPASchedulesLaunchCount];
    }
    
    [self setUpAppearances];
    
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

- (void)setUpAppearances {
    [[UINavigationBar appearance] setBarTintColor:PA_BLUE];
    [[UINavigationBar appearance] setTintColor:PA_WHITE];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : PA_WHITE}];
    
    [[UITabBar appearance] setTintColor:PA_BLUE];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kPASchedulesLaunchCount] >= 5) {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]} forState:UIControlStateNormal];
    }
    
    [[UISegmentedControl appearance] setTintColor:PA_BLUE];
    [[UISegmentedControl appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:PA_WHITE];
}

@end
