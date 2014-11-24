//
//  PATemplateTableViewController.h
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+EmptyDataSet.h"

@interface PATemplateTableViewController : UITableViewController <PASessionDelegate, UIScrollViewDelegate, UITextFieldDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

#pragma mark - Properties

/**
 *  Stops the refreshControl from showing on viewDidLoad:.
 */
@property (nonatomic) BOOL shouldNotLoadRefreshing;

@end
