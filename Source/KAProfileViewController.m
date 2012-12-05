//
//  KAProfileViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAProfileViewController.h"
#import "AuthAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "KACredentialStore.h"
#import "MBProgressHUD.h"

@interface KAProfileViewController ()

@end

@implementation KAProfileViewController

@synthesize profilePhoto;

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
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    username.text = nil;
    numberOfMeals.text = nil;    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self configureProperties:responseObject];
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"%@", error);
                                  }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureProperties:(id)userDictionary
{
    NSLog(@"Username: %@", [userDictionary objectForKey:@"username"]);
    username.text = [userDictionary objectForKey:@"username"];
    NSLog(@"# of Meals: %@", [userDictionary objectForKey:@"meals"]);
    numberOfMeals.text = [NSString stringWithFormat:@"%@", [userDictionary objectForKey:@"meals"]];
    
    NSLog(@"Photo URL: %@", [userDictionary objectForKey:@"avatar_square"]);
    NSURL *photoURL = [NSURL URLWithString:[userDictionary objectForKey:@"avatar_square"]];
    [profilePhoto setImageWithURL:photoURL];
    
}

#pragma mark - Logout / terminate session

-(IBAction)logout:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:@"Logout"
                        otherButtonTitles:nil]
     showFromTabBar:self.tabBarController.tabBar];
}


- (void)terminateUserSession
{
    KACredentialStore *store = [[KACredentialStore alloc] init];
    [store clearSavedCredentials];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self terminateUserSession]; break;
    }
}

@end
