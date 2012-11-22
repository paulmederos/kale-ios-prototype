//
//  KAMealViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAMealViewController.h"
#import "UIImageView+AFNetworking.h"

@interface KAMealViewController ()

@end

@implementation KAMealViewController

@synthesize meal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [titleLabel setText:[meal title]];
    [usernameLabel setText:[meal ownerUsername]];
    
    [photo setImageWithURL:[NSURL URLWithString:[meal photoSquareURL]]
          placeholderImage:[UIImage imageNamed:@"meal-default.png"]];
    
    [userAvatar setImageWithURL:[NSURL URLWithString:[meal ownerAvatarThumbURL]]
                                    placeholderImage:[UIImage imageNamed:@"meal-default.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
