//
//  TETextFieldCell.h
//  TextExchange
//
//  Created by Rudd Fawcett on 9/12/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PATextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIImage *icon;

@end
