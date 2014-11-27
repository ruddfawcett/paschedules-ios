//
//  TETextFieldCell.h
//  TextExchange
//
//  Created by Rudd Fawcett on 9/12/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PATextFieldCell : UITableViewCell <UITextFieldDelegate>

/**
 *  The textfield of the cell.
 */
@property (strong, nonatomic) UITextField *textField;

/**
 *  The icon that is assigned to the cell's imageView.
 */
@property (strong, nonatomic) UIImage *icon;

#pragma mark - Class Methods

/**
 *  Returns a cell
 *
 *  @param reuseIdentifier The cell reuse identiifer.
 *
 *  @return A UITableViewCell.
 */
+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
