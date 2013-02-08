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

@end

@implementation KAShareViewController

@synthesize mealPhoto, mealTitle, pickerController, photoButton, proudImage, proudButton, proudOfMeal, proudTextLabel, descriptionCounter;

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


- (void)postMeal:(id)sender
{
    NSLog(@"This is where we finish uploading stuff to server!");
    KAMeal *meal = [[KAMeal alloc] init];
    
    meal.title = self.mealTitle.text;
    meal.photoData = UIImageJPEGRepresentation(mealPhoto.image, 0.8f);
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
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"Posting the MealPostedNotification.");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"MealPostedNotification"
             object:self];
            
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger textLength = 0;
    textLength = [textView.text length] - range.length;
    self.descriptionCounter.text = [NSString stringWithFormat:@"%d", 139 - textLength];
    if (textLength >= 140) {
        self.descriptionCounter.textColor = [UIColor redColor];
    } else {
        self.descriptionCounter.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

#pragma mark - UI Customizations

- (void)customizeAppearance
{
    // Set the title
    self.navigationItem.title = @"Share Food";
    
    // Set background colors/images
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light_toast.png"]];
    
    mealTitle.delegate = self;
    mealTitle.backgroundColor = [UIColor whiteColor];
    mealTitle.placeholderTextColor = [UIColor lightGrayColor];
    [mealTitle.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [mealTitle.layer setBorderWidth:1.0f];
    [mealTitle.layer setCornerRadius:2.0f];
    [mealTitle setPlaceholder:@"What are you eating?"];
    [mealTitle setPlaceholderTextColor:[UIColor lightGrayColor]];
    
    [mealPhoto.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mealPhoto.layer setBorderWidth:4.0f];
    [mealPhoto.layer setShadowColor:[UIColor blackColor].CGColor];
    [mealPhoto.layer setShadowOpacity:0.3];
    [mealPhoto.layer setShadowRadius:1.0];
    [mealPhoto.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    [mealPhoto setImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
    
    [proudImage setImage:[UIImage imageNamed:@"share-proud_of_meal.png"]];
    proudTextLabel.text = @"I'm proud of eating this!";
    proudOfMeal = YES;
    
    
    // Set navigation button styles / actions
    UIBarButtonItem *postMealButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(postMeal:)];
    self.navigationItem.rightBarButtonItem = postMealButton;
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
    if (proudOfMeal) {
        proudOfMeal = NO;
        UIImage * toImage = [UIImage imageNamed:@"share-dont_share_meal.png"];
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
        UIImage * toImage = [UIImage imageNamed:@"share-proud_of_meal.png"];
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
    
    CGRect titleFrame = self.mealTitle.frame;
    titleFrame.origin.y = titleFrame.origin.y - 100.0f;
    self.mealTitle.frame = titleFrame;
    
    CGRect countFrame = self.descriptionCounter.frame;
    countFrame.origin.y = countFrame.origin.y - 100.0f;
    self.descriptionCounter.frame = countFrame;
    
    CGRect imageFrame = self.mealPhoto.frame;
    imageFrame.origin.y = imageFrame.origin.y - 100.0f;
    self.mealPhoto.frame = imageFrame;
    self.photoButton.frame = imageFrame;
    
    CGRect proudFrame = self.proudImage.frame;
    proudFrame.origin.y = proudFrame.origin.y - 100.0f;
    self.proudImage.frame = proudFrame;
    self.proudButton.frame = proudFrame;
    
    CGRect proudLabelFrame = self.proudTextLabel.frame;
    proudLabelFrame.origin.y = proudLabelFrame.origin.y - 100.0f;
    self.proudTextLabel.frame = proudLabelFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    CGRect imageFrame = self.mealPhoto.frame;
    imageFrame.origin.y = 10.0f;
    self.mealPhoto.frame = imageFrame;
    self.photoButton.frame = imageFrame;
    
    CGRect titleFrame = self.mealTitle.frame;
    titleFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + 10.0f;
    self.mealTitle.frame = titleFrame;
    
    CGRect counterFrame = titleFrame;
    counterFrame.origin.y = counterFrame.origin.y + (titleFrame.size.height/2.0f) - 12.0f;
    counterFrame.origin.x = counterFrame.origin.x - 6.0f;
    self.descriptionCounter.frame = counterFrame;
    
    CGRect proudFrame = self.proudImage.frame;
    proudFrame.origin.y = 10.f;
    self.proudImage.frame = proudFrame;
    self.proudButton.frame = proudFrame;
    
    CGRect proudLabelFrame = self.proudTextLabel.frame;
    proudLabelFrame.origin.y = proudFrame.origin.y + proudFrame.size.height + 10.0f;
    self.proudTextLabel.frame = proudLabelFrame;

    
    [UIView commitAnimations];
}

#pragma mark - Logout / terminate session

-(IBAction)choosePhoto:(id)sender
{
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


@end
