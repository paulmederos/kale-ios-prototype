//
//  KAFeedNavigationController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAFeedNavigationController.h"

@interface KAFeedNavigationController ()

@end

@implementation KAFeedNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed"
                                                        image:nil tag:0];
        [self.tabBarItem
         setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-global-selected.png"]
         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-global.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
