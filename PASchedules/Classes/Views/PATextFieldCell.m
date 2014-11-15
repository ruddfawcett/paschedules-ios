//
//  TETextFieldCell.m
//  TextExchange
//
//  Created by Rudd Fawcett on 9/12/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATextFieldCell.h"

@implementation PATextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGRect frame = CGRectMake(15, 12, self.bounds.size.width-(2*15), 21);
        
        self.textField.frame = frame;
        self.textField = [[UITextField alloc] initWithFrame:frame];
        self.textField.textColor = [UIColor blackColor];
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.keyboardAppearance = UIKeyboardAppearanceLight;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.enabled = YES;
        self.textField.textColor = PA_DARK;
        
        self.textField.delegate = self;
        
        [self.contentView addSubview:self.textField];
    }
    
    return self;
}

- (void)setIcon:(UIImage *)icon {
    self.imageView.image = icon;
    
    CGRect frame = CGRectMake(15, 12, self.bounds.size.width-(2*15), 21);
    
    if (icon != nil) {
        frame.origin.x += 40;
        frame.size.width -= 40;
    }
    
    self.textField.frame = frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
    
    return YES;
}

@end
