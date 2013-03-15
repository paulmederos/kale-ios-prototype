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


#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


@interface KAWelcomeViewController ()
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
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.credentialStore isLoggedIn]) {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
}


@end
