//
//  KAFeedTableViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KAFeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *meals;

@end
