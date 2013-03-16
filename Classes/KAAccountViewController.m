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
@property (strong, nonatomic) UIImagePickerController *pickerController;
@end

@implementation KAAccountViewController

@synthesize usernameField, emailField, profileImage, pickerController;

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
    
    // Instantiate any instance vars
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Configure delegates
    [usernameField setDelegate:self];
    [emailField setDelegate:self];
    
    // Customize appearances
    [self customizeAppearance];
}

- (void)viewDidAppear:(BOOL)animated
{
    pickerController  = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.navigationItem.title = @"Camera";
}

- (void)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)customizeAppearance
{
    usernameField.text = [defaults objectForKey:@"username"];
    emailField.text = [defaults objectForKey:@"email"];
    
    NSURL *profileImageURL = [[NSURL alloc] initWithString:[defaults objectForKey:@"avatar_thumb"]];
    [profileImage setImageWithURL:profileImageURL placeholderImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
    
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
    
    // Make the POST/PUT request
    NSString *url = [NSString stringWithFormat:@"/api/v1/users/%@", [defaults objectForKey:@"serverID"]];    
    NSURLRequest *putRequest = [[AuthAPIClient sharedClient]
                                multipartFormRequestWithMethod:@"PUT"
                                path:url
                                parameters:params
                                constructingBodyWithBlock:^(id formData) {
                                     [formData appendPartWithFileData:UIImageJPEGRepresentation(self.profileImage.image, 100)
                                                                 name:@"user[avatar]"
                                                             fileName:@"avatar.jpg"
                                                             mimeType:@"image/jpg"];
                                     
                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:putRequest];
    NSLog(@"Creating PUT operation.");
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        hud.progress = progress;
        if (progress == 1.0){
            hud.mode = MBProgressHUDModeText;
            [hud setLabelText:@"Profile updated :)"];
            [hud hide:YES afterDelay:1];
        }
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // User has been updated. Re-configure NSUserDefaults, close modal, hide hud, and post notification
        [self configureUserDefaults:responseObject];
        [self closeSettings:self];
        [hud hide:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUpdatedNotification" object:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // If fail, show error message and don't close.
        NSLog(@"Error saving user: %@", error);
        [hud setLabelText:@"Error :("];
        [hud hide:YES afterDelay:2];
    }];
    
    [[AuthAPIClient sharedClient] enqueueHTTPRequestOperation:operation];

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

- (void)openWebsiteResetPassword:(id)sender
{
    NSString* launchUrl = @"https://kaleweb.herokuapp.com/password_resets/new";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (void)showProfilePhotoActions
{
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Take Photo", @"Choose From Saved", nil]
     showInView:self.view];
    
}

#pragma mark - UIImagePickerDelegate

- (void)takePhoto:(id)sender {
    [self presentViewController:pickerController animated:NO completion:nil];
}

- (void)choosePhotoFromAlbum:(id)sender
{
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerController animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [pickerController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Canceled the camera action.");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    // Next, Pass the image reference
    [self.profileImage setImage:editedPhoto];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // If we have a camera, take a picture. If not, use Photo Library.
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No camera found" message:@"Sorry, we can't seem to detect a camera on your device." delegate:self cancelButtonTitle:@"Oh well" otherButtonTitles:nil];
                [alert show];
                break;
            }
            [self takePhoto:nil]; break;
        case 1:
            [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self takePhoto:nil];
            break;
        case 2:
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Touched %@", indexPath);
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"Show photo action sheet.");
        [self showProfilePhotoActions];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        NSLog(@"Show web app with password reset.");
        [self openWebsiteResetPassword:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
