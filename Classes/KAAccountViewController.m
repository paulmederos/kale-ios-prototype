//
//  KAAccountViewController.m
//  Kale
//
//  Created by Paul Mederos on 3/14/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KAAccountViewController.h"
#import "KAToolbar.h"

#import "UIImageView+AFNetworking.h"

@interface KAAccountViewController ()

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    usernameField.text = [defaults objectForKey:@"username"];
    emailField.text = [defaults objectForKey:@"email"];
    NSURL *profileURL = [[NSURL alloc] initWithString:[defaults objectForKey:@"avatar_thumb"]];
    [profileImage setImageWithURL:profileURL placeholderImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
    
    [usernameField setDelegate:self];
    [emailField setDelegate:self];
    
    KAToolbar *toolbar = [[KAToolbar alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
    
    [self.view addSubview:toolbar];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:245.0/255.0f
                                                       green:239.0/255.0f
                                                        blue:233.0/255.0f
                                                       alpha:1.0]];
    
}

- (void)closeSettings:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
