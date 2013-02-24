//
//  KAWelcomeViewController.m
//  Kale
//
//  Created by Paul Mederos on 2/22/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KACredentialStore.h"
#import "KASignupViewController.h"
#import "KAWelcomeViewController.h"


@interface KAWelcomeViewController ()
@property (nonatomic, strong) KACredentialStore *credentialStore;
@property (strong, nonatomic) KASignupViewController *svc;

@end


@implementation KAWelcomeViewController

@synthesize svc;

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
    self.credentialStore = [[KACredentialStore alloc] init];
    
    svc = [self.storyboard instantiateViewControllerWithIdentifier:@"signupWebView"];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.credentialStore isLoggedIn]) {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
}

// Using UIWebView modal for registration for now
- (IBAction)openWebsiteSignup:(id)sender {    
    [self presentViewController:svc animated:YES completion:nil];
}


@end
