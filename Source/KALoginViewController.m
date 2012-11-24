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

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)login:(id)sender {
    
    // Check to see if values have been entered
    id params = @{
        @"email": self.emailField.text,
        @"password": self.passwordField.text
    };
    
    NSLog(@"About to send to server...");
    
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

@end
