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
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self configureProperties:responseObject];
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
    username.text = [userDictionary objectForKey:@"username"];
    numberOfMeals.text = [userDictionary objectForKey:@"meals"];
    NSURL *photoURL = [NSURL URLWithString:[userDictionary objectForKey:@"avatar_square"]];
    [profilePhoto setImageWithURL:photoURL];
    
}

@end
