//
//  KAFeedTableViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"


@interface KAFeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, SSPullToRefreshViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSArray *meals;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;


@end
