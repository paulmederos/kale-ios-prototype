//
//  KASignupViewController.m
//  Kale
//
//  Created by Paul Mederos on 2/7/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KACredentialStore.h"
#import "KASignupViewController.h"

@interface KASignupViewController ()

@property (nonatomic, strong) KACredentialStore *credentialStore;

@end

@implementation KASignupViewController

@synthesize signupWebView;

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
    
    self.credentialStore = [[KACredentialStore alloc] init];
    
    NSString *fullURL = @"https://kaleweb.herokuapp.com/signup-mobile";
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:fullURL]];

    [self.signupWebView setDelegate:self];
    [self.signupWebView loadRequest:requestObj];
    
    [self setTitle:@"Sign Up"];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.credentialStore isLoggedIn]) {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
}


- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    hud.labelText = @"Loading";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished Loading webView...");
    [MBProgressHUD hideHUDForView:webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error loading: %@", error);
    [MBProgressHUD hideHUDForView:webView animated:YES];
}


@end
