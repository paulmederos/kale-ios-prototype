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

@synthesize webView;

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
    [webView loadRequest:requestObj];
    [self setTitle:@"Sign Up"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeWebView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
