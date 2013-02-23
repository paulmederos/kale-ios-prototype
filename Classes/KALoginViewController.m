//
//  KAWelcomeViewController.m
//  Kale
//
//  Created by Paul Mederos on 2/22/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//


#import "AuthAPIClient.h"
#import "KACredentialStore.h"
#import "KALoginViewController.h"
#import "MBProgressHUD.h"


#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


@interface KALoginViewController ()

@property (nonatomic, strong) KACredentialStore *credentialStore;

@end

@implementation KALoginViewController

@synthesize emailField, passwordField, outputLabel;

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [emailField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.credentialStore = [[KACredentialStore alloc] init];
    
    [emailField setTextEdgeInsets:UIEdgeInsetsMake(0.0, 12.0f, 0, 12.0f)];
    [passwordField setTextEdgeInsets:UIEdgeInsetsMake(0.0, 12.0f, 0, 12.0f)];
    [self customizeTextFields];
    [self setBackButton];
}

- (void)customizeTextFields
{
    [self.emailField setDelegate:self];
    [self.passwordField setDelegate:self];
}

- (void)setBackButton
{
    UIButton *backButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"controls-nav-back-arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 36.0, 18.0f)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
                                       [self.credentialStore setAuthToken:authToken];
                                       
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


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }
}


@end
