//
//  KAWelcomeViewController.m
//  Kale
//
//  Created by Paul Mederos on 2/22/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KAWelcomeViewController.h"
#import "KASignupViewController.h"

@interface KAWelcomeViewController ()

@end

@implementation KAWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

// Using UIWebView modal for registration for now
- (IBAction)openWebsiteSignup:(id)sender {
    KASignupViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"signupWebView"];
    
    
    [self presentViewController:svc animated:YES completion:^{
        [svc.signupWebView setDelegate:self];
    }];
}

@end
