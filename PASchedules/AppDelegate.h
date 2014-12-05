//
//  AppDelegate.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/7/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PASchedulesAPI;
@class PANavigationController;
@class PALoginViewController;
@class PATabBarController;
@class PAStudentViewController;

#define kSystemVersion [UIDevice currentDevice].systemVersion
#define kDeviceType CTFeedbackViewController.new.platformString
#define kDeviceName [UIDevice currentDevice].name
#define kAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kAppBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]

extern NSString * const kPASchedulesFirstLaunch;
extern NSString * const kPASchedulesLaunchCount;
extern NSString * const kPASchedulesErrorDomain;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

