//
//  KALoginViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KALoginViewController.h"
#import "AuthAPIClient.h"
#import "KACredentialStore.h"
#import "MBProgressHUD.h"

@interface KALoginViewController ()

@property (nonatomic, strong) KACredentialStore *credentialStore;

@end

@implementation KALoginViewController

@synthesize outputLabel;

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
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-bg.png"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self customizeTextFields];
    [self customizeLoginButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    outputLabel.text = @"Welcome to Kale.";
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([self.credentialStore isLoggedIn]) {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {    
    // Check to see if values have been entered
    id params = @{
        @"email": self.emailField.text,
        @"password": self.passwordField.text
    };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [hud setAnimationType:MBProgressHUDModeIndeterminate];
    [hud show:YES];
    outputLabel.text = nil;
    
    // Send values to server
    [[AuthAPIClient sharedClient] postPath:@"api/v1/auth/login"
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // If server returns auth token, set current user
       // and then perform segue to mainTabBarController
           NSLog(@"Received successful auth. Response is %@", [responseObject class]);
           NSString *authToken = [responseObject objectForKey:@"auth_token"];
           NSLog(@"auth_token is %@", authToken);
           
           [self.credentialStore setAuthToken:authToken];
           NSLog(@"Set the token in the credential store.");
           
           
           [MBProgressHUD hideHUDForView:self.view animated:YES];
           [self performSegueWithIdentifier:@"loginSuccess" sender:self];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // else, display the error of why it wasn't successful
           NSLog(@"Failure...");
           if (operation.response.statusCode == 500) {
               NSLog(@"500");
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               outputLabel.text = @"Something went wrong with Kale's servers.";
               
           } else {
               NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:0
                                                                      error:nil];
               NSString *errorMessage = [json objectForKey:@"error"];
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               NSLog(@"Other error: %@", errorMessage);
               outputLabel.text = errorMessage;
           }
       }];
}

#pragma mark - Customize UI

- (void)customizeTextFields
{
    [self.emailField setDelegate:self];
    [self.passwordField setDelegate:self];
    
    CGRect frameRect = self.emailField.frame;
    frameRect.size.height = 80.0f;
    self.emailField.frame = frameRect;
    
}

- (void)customizeLoginButton
{
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login-button.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login-button_highlighted.png"] forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login-button_selected.png"] forState:UIControlStateSelected];
}


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Tag is %d", textField.tag);
    if (textField.tag == 0) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }

    return YES;
}

@end
