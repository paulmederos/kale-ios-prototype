//
//  KAWelcomeViewController.m
//  Kale
//
//  Created by Paul Mederos on 2/22/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "AuthAPIClient.h"

#import "KACredentialStore.h"
#import "KASignupViewController.h"
#import "KAWelcomeViewController.h"



#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


@interface KAWelcomeViewController ()
{
    NSUserDefaults *defaults;
}

@property (nonatomic, strong) KACredentialStore *credentialStore;

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
    self.credentialStore = [[KACredentialStore alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.credentialStore isLoggedIn]) {
        [self getCurrentUserData];
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
}

- (void)getCurrentUserData
{
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"API/Profile success. Response is: %@", responseObject);
                                      [self configureUserDefaults:responseObject];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Error pulling user Personal data: %@", error);
                                  }];
}

- (void)configureUserDefaults:(id)userDictionary
{
    [defaults setObject:[userDictionary objectForKey:@"username"] forKey:@"username"];
    [defaults setObject:[userDictionary objectForKey:@"email"] forKey:@"email"];
    [defaults setObject:[userDictionary objectForKey:@"avatar_square"] forKey:@"avatar_square"];
    [defaults setObject:[userDictionary objectForKey:@"avatar_thumb"] forKey:@"avatar_thumb"];
    [defaults setObject:[userDictionary objectForKey:@"id"] forKey:@"serverID"];
    [defaults setObject:[userDictionary objectForKey:@"meals"] forKey:@"meals"];
    [defaults setObject:[userDictionary objectForKey:@"following"] forKey:@"following"];
    [defaults setObject:[userDictionary objectForKey:@"followers"] forKey:@"followers"];
    [defaults setObject:[userDictionary objectForKey:@"name"] forKey:@"name"];
    [defaults setObject:[userDictionary objectForKey:@"location"] forKey:@"location"];
    [defaults setObject:[userDictionary objectForKey:@"goal"] forKey:@"goal"];
    
    NSLog(@"User '%@' with ID %@ is now logged in.", [defaults objectForKey:@"name"], [defaults objectForKey:@"serverID"]);
}


@end
