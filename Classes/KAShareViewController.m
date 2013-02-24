//
//  KAShareViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 12/1/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KAShareViewController.h"
#import "KAMainNavigationBar.h"
#import "KAMeal.h"
#import "MBProgressHUD.h"


@interface KAShareViewController ()


@property (strong, nonatomic) UIImagePickerController *pickerController;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIImageView *proudImage;
@property (weak, nonatomic) IBOutlet UIButton *proudButton;
@property (nonatomic) bool proudOfMeal;
@property (weak, nonatomic) IBOutlet UILabel *proudTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCounter;
@property (weak, nonatomic) IBOutlet UIButton *submitMealButton;

@end

@implementation KAShareViewController

@synthesize mealPhoto, mealTitle, pickerController, photoButton, proudImage, proudButton, proudOfMeal, proudTextLabel, descriptionCounter, submitMealButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Loaded from usual suspect.");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeAppearance];
    [self.submitMealButton addTarget:self action:@selector(postMeal:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postMeal:(id)sender
{
    NSLog(@"This is where we finish uploading stuff to server!");
    KAMeal *meal = [[KAMeal alloc] init];
    
    meal.title = self.mealTitle.text;
    meal.photoData = UIImageJPEGRepresentation(mealPhoto.image, 0.8f);
    
    UIImage *placeholder = [UIImage imageNamed:@"share-photo-placeholder.png"];
    if ([meal.photoData isEqualToData:UIImageJPEGRepresentation(placeholder, 0.8f)])
    {
        NSLog(@"Empty photo");
        meal.photoData = UIImageJPEGRepresentation([UIImage imageNamed:@"meal_photo-placeholder.png"], 0.8f);;
    }
    
    NSLog(@"Meal photo is: %@", meal.photoData);
    
    meal.proudOfMeal = self.proudOfMeal;
    
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    // save it
    [meal saveWithProgress:^(CGFloat progress) {
        hud.progress = progress;
    } completion:^(BOOL success, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"Posting the MealPostedNotification.");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"MealPostedNotification"
             object:self];
            
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

#pragma mark - UI Customizations

- (void)customizeAppearance
{
    // Set the title
    self.navigationItem.title = @"Log Your Food";
    
    // Set background colors/images
    mealTitle.delegate = self;
    mealTitle.backgroundColor = [UIColor whiteColor];
    mealTitle.placeholderTextColor = [UIColor lightGrayColor];
    [mealTitle.layer setBorderColor:[UIColor colorWithRed:220.0/255.0f green:215.0/255.0f blue:209.0/255.0f alpha:1.0].CGColor];
    [mealTitle.layer setBorderWidth:1.0f];
    [mealTitle.layer setCornerRadius:2.0f];
    [mealTitle setPlaceholder:@"What are you eating?"];
    [mealTitle setPlaceholderTextColor:[UIColor lightGrayColor]];
    
    [mealPhoto setImage:[UIImage imageNamed:@"share-photo-placeholder.png"]];
    
    [proudImage setImage:[UIImage imageNamed:@"controls-proud-switch.png"]];
    proudTextLabel.text = @"I'm proud of eating this!";
    proudOfMeal = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.mealTitle resignFirstResponder];
    }
}

- (void)takePhoto:(id)sender {
    [self presentViewController:pickerController animated:NO completion:nil];
}

- (void)choosePhotoFromAlbum:(id)sender
{
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerController animated:NO completion:nil];
}

- (IBAction)toggleProud:(id)sender {
    [self.mealTitle resignFirstResponder];
    if (proudOfMeal) {
        proudOfMeal = NO;
        [submitMealButton setTitle:@"Log This Meal" forState:UIControlStateNormal];
        UIImage * toImage = [UIImage imageNamed:@"controls-private-switch.png"];
        [UIView transitionWithView:proudImage
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            proudImage.image = toImage;
                        } completion:NULL];
        
        proudTextLabel.text = @"Keep this to myself.";
    } else {
        proudOfMeal = YES;
        proudTextLabel.text = @"I'm proud of eating this!";
        [submitMealButton setTitle:@"Share This Meal" forState:UIControlStateNormal];
        UIImage * toImage = [UIImage imageNamed:@"controls-proud-switch.png"];
        [UIView transitionWithView:proudImage
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            proudImage.image = toImage;
                        } completion:NULL];
    }
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [pickerController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Canceled the camera action.");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImageWriteToSavedPhotosAlbum(editedPhoto, nil, nil, nil);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    // Next, Pass the image reference
    [self.mealPhoto setImage:editedPhoto];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView delegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}


#pragma mark - Keyboard show/hide

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 100.0f);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 100.0f);
    [UIView commitAnimations];
}

#pragma mark - Logout / terminate session

-(IBAction)choosePhoto:(id)sender
{
    [self.mealTitle resignFirstResponder];
    pickerController  = [[UIImagePickerController alloc] init];
    
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.navigationItem.title = @"Camera";
    
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Take Photo", @"Choose From Saved", nil]
                            showInView:self.view];
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

#pragma mark - UITextView delegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Count the characters in textfield, show limit of 140.
    NSInteger textLength = 0;
    textLength = [textView.text length] - range.length;
    self.descriptionCounter.text = [NSString stringWithFormat:@"%d", 139 - textLength];
    if (textLength >= 140) {
        self.descriptionCounter.textColor = [UIColor redColor];
    } else {
        self.descriptionCounter.textColor = [UIColor lightGrayColor];
    }
    
    // Enter/Done should resign keyboard
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
