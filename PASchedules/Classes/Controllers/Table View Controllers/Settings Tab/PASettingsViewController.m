//
//  PASettingsViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/26/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PASettingsViewController.h"

#import "PALoginViewController.h"

NSString * NSStringFromSettingsSections(PASettingsTableViewSections section) {
    switch (section) {
        case PASettingsTableViewSectionUser:
            return @"My Account";
            break;
        case PASettingsTableViewSectionFeedback:
            return @"Comments or Suggestions";
            break;
        default:
            return @"Acknowledgments";
            break;
    }
};


static NSString * kPALogoutIdentifier = @"Logout";
static NSString * kPAForgotIdentifier = @"Forgot";
static NSString * kPAAcknowledgmentIdentifier = @"Acknowledgment";

@implementation PASettingsViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        [PASchedulesAPI sharedClient].delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSStringFromSettingsSections(section);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == PASettingsTableViewSectionUser ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPALogoutIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPALogoutIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == PASettingsTableViewSectionUser) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Logout";
        }
        else cell.textLabel.text = @"Change Password";
    }
    else if (indexPath.section == PASettingsTableViewSectionFeedback) {
        cell.textLabel.text = @"Feedback";
    }
    else {
        cell.textLabel.text = @"Third Party";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PASettingsTableViewSectionUser) {
        if (indexPath.row == 0) {
            [SVProgressHUD showWithStatus:@"Logging Out..." maskType:SVProgressHUDMaskTypeGradient];
            
            [[PASchedulesAPI sharedClient] logout:^(BOOL *success) {
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [NSError showWithError:[NSError errorWithDomain:kPASchedulesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Unable to log you out."}]];
            }];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://paschedules.herokuapp.com/users/edit"]];
        }
    }
    else if (indexPath.section == PASettingsTableViewSectionFeedback) {
        
        CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
        feedbackViewController.hidesScreenshotCell = YES;
        feedbackViewController.useHTML = YES;
        feedbackViewController.toRecipients = @[@"rfawcett@andover.edu"];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    }
    else {
        VTAcknowledgementsViewController *viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sessionDidEnd:(NSDictionary *)result {
    PANavigationController *navController = [[PANavigationController alloc] initWithRootViewController:[PALoginViewController new]];
    
    [[UIApplication sharedApplication] delegate].window.rootViewController = navController;
}

@end
