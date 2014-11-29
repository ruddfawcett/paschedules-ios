//
//  PASettingsViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SVProgressHUD/SVProgressHUD.h>
#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>
#import <CTFeedback/CTFeedbackViewController.h>

@class PALoginViewController;

typedef NS_ENUM(NSUInteger, PASettingsTableViewSections) {
    PASettingsTableViewSectionUser,
    PASettingsTableViewSectionFeedback,
    PASettingsTableViewSectionAcknowledgments
};

@interface PASettingsViewController : UITableViewController <PASessionDelegate>

@end
