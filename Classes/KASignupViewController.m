//
//  KASignupViewController.m
//  Kale
//
//  Created by Paul Mederos on 2/7/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KASignupViewController.h"

@interface KASignupViewController ()

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
    
    NSString *fullURL = @"https://kaleweb.herokuapp.com/signup-mobile";
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:fullURL]];

    [self.signupWebView setDelegate:self];
    [self.signupWebView loadRequest:requestObj];
    
    [self setTitle:@"Sign Up"];
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
