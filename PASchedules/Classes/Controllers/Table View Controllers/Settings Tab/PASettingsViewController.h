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

@class PALoginViewController;

typedef NS_ENUM(NSUInteger, PASettingsTableViewSections) {
    PASettingsTableViewSectionUser,
    PASettingsTableViewSectionAcknowledgments,
    
};

@interface PASettingsViewController : UITableViewController <PASessionDelegate>

@end
