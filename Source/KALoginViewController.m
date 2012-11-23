//
//  KALoginViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KALoginViewController.h"

@interface KALoginViewController ()

@end

@implementation KALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)login:(id)sender {
    // Check to see if values have been entered
    
    // Send values to server
    
    // If server returns auth token, set current user
    // and then perform segue to mainTabBarController
    
    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    
    // else, display error
    
}

@end
