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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (!self.shouldNotLoadRefreshing) {
        [self.refreshControl beginRefreshing];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self setNeedsStatusBarAppearanceUpdate];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)sessionDidEnd:(NSDictionary *)result {
    NSLog(@"session went caput");
}

@end
