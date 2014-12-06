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
NSString * const kPAMinutes = @"App Active";

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
    
    [Fabric with:@[CrashlyticsKit]];
    [Mixpanel sharedInstanceWithToken:keys.mixpanelToken];
    
    if (FORCE_LOGIN) {
        NSString *kPASchedulesDidLogOut = [NSString stringWithFormat:@"com.ruddfawcett.paschedules.logout.%@",kAppBuild];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kPASchedulesDidLogOut]) {
            [PASchedulesAPI destroySession];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPASchedulesDidLogOut];
        }
    }
    
    if ([PASchedulesAPI currentUser]) {
//        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
//            // iOS 8 Notifications
//            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//            
//            [application registerForRemoteNotifications];
//        }
//        else {
//            // iOS < 8 Notifications
//            [application registerForRemoteNotificationTypes:
//             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
//        }
    }
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if ([PASchedulesAPI currentUser]) {
        [Mixpanel identifyStudent:[[PASchedulesAPI sharedClient] currentStudent]];
    }
    
    NSLog(@"%@",deviceToken);
    
    [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error) {
        [NSError showWithError:error];
    }
    
    NSLog(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[Mixpanel sharedInstance] timeEvent:kPAMinutes];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [Mixpanel track:kPAMinutes];
}

@end
