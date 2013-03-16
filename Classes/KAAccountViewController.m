//
//  KAAccountViewController.m
//  Kale
//
//  Created by Paul Mederos on 3/14/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KAAccountViewController.h"
#import "KAToolbar.h"

#import "AuthAPIClient.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface KAAccountViewController ()
{
    NSUserDefaults *defaults;   
}
@end

@implementation KAAccountViewController

@synthesize usernameField, emailField, profileImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    usernameField.text = [defaults objectForKey:@"username"];
    emailField.text = [defaults objectForKey:@"email"];
    NSURL *profileURL = [[NSURL alloc] initWithString:[defaults objectForKey:@"avatar_thumb"]];
    [profileImage setImageWithURL:profileURL placeholderImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
    
    [usernameField setDelegate:self];
    [emailField setDelegate:self];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:245.0/255.0f
                                                       green:239.0/255.0f
                                                        blue:233.0/255.0f
                                                       alpha:1.0]];
    
    UIButton *closeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"nav-close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettings:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setFrame:CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIButton *saveButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:[UIImage imageNamed:@"nav-close.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveSettings:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonSystemItemDone target:self action:@selector(saveSettings:)];
    
}

- (void)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveSettings:(id)sender
{
    NSLog(@"Saving settings.");
    // Resign responder and show progress hud
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    // Validate for blanks
    if ( usernameField.text == nil)
    {
        NSLog(@"No username. Setting to default.");
        usernameField.text = [defaults objectForKey:@"username"];
    }
    
    if ( emailField.text == nil)
    {
        NSLog(@"No username. Setting to default.");
        emailField.text = [defaults objectForKey:@"email"];
    }    
    
    // Create params to send to server.
    NSDictionary *params = @{
        @"username" : usernameField.text,
        @"email" : emailField.text
    };
    
    // Make the POST request
    NSString *url = [NSString stringWithFormat:@"/api/v1/users/%@", [defaults objectForKey:@"serverID"]];
    [[AuthAPIClient sharedClient] putPath:url
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       // If successful to server, save NSUserDefaults, close to Profile and refresh view.
                                       [self configureUserDefaults:responseObject];
                                       [self closeSettings:self];
                                       [hud hide:YES];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error saving user: %@", error);
                                       [hud setLabelText:@"Error :("];
                                       [hud hide:YES afterDelay:2];
                                   }];
    
    
    
    // If fail, show error message and don't close.

}

- (void)configureUserDefaults:(id)userDictionary
{
    [defaults setObject:[userDictionary objectForKey:@"username"] forKey:@"username"];
    [defaults setObject:[userDictionary objectForKey:@"email"] forKey:@"email"];
    [defaults setObject:[userDictionary objectForKey:@"avatar_square"] forKey:@"avatar_square"];
    [defaults setObject:[userDictionary objectForKey:@"avatar_thumb"] forKey:@"avatar_thumb"];
    [defaults setObject:[userDictionary objectForKey:@"id"] forKey:@"serverID"];
    [defaults setObject:[userDictionary objectForKey:@"meals"] forKey:@"mealsCount"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Touched %@", indexPath);
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"Show photo action sheet.");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
