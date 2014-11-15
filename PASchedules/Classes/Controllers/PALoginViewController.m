//
//  TELoginViewController.m
//  TextExchange
//
//  Created by Rudd Fawcett on 9/12/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PALoginViewController.h"

#import "PATextFieldCell.h"

@interface PALoginViewController () <UITextFieldDelegate, PASessionDelegate>

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;

@property (strong, nonatomic) NSString *andoverUsername;

@end

@implementation PALoginViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.tableView.separatorColor = [UIColor whiteColor];
        
        [PASchedulesAPI sharedClient].currentUser.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Log In";
}

- (void)viewDidAppear:(BOOL)animated {
    if (TESTING) {
        [self.passwordField becomeFirstResponder];
    }
    
    [super viewDidAppear:animated];
}

- (void)loginUser {
    NSLog(@"Logging in...");
    
    [[PASchedulesAPI sharedClient] login:self.usernameField.text withPassword:self.passwordField.text success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [SVProgressHUD showSuccessWithStatus:@"Logged In"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NSError showWithError:error];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.usernameField && ([string isEqualToString:@"@"] || [string isEqualToString:@"."])) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.usernameField) textField.text = self.andoverUsername;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField endEditing:YES];
    
    if (textField == self.usernameField) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"@andover.edu" withString:@""];
        self.andoverUsername = textField.text;
        
        if (textField.text.length != 0) {
            textField.text = [textField.text stringByAppendingString:@"@andover.edu"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    else {
        [self.view endEditing:YES];
        
        [SVProgressHUD showWithStatus:@"Logging In..." maskType:SVProgressHUDMaskTypeGradient];
        [self loginUser];
    }
    
    return YES;
}

# pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PATextFieldCell *cell = [[PATextFieldCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.icon = [UIImage maskedImageWithName:@"envelope" color:PA_DARK];
        cell.textField.placeholder = @"Andover Username";
        cell.textField.text = TEST_USER_EMAIL;
        cell.textField.returnKeyType = UIReturnKeyNext;
        self.usernameField = cell.textField;
    }
    else {
        cell.icon = [UIImage maskedImageWithName:@"lock" color:PA_DARK];
        cell.textField.placeholder = @"Password";
        cell.textField.text = TEST_USER_PASSWORD;
        cell.textField.secureTextEntry = YES;
        self.passwordField = cell.textField;
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

@end
