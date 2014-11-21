//
//  PATemplateTableViewController.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/18/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PATemplateTableViewController.h"

@implementation PATemplateTableViewController

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        [PASchedulesAPI sharedClient].delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    if (!self.shouldNotLoadRefreshing) {
        [self.refreshControl beginRefreshing];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)sessionDidEnd:(NSDictionary *)result {
    NSLog(@"session went caput");
}

@end
