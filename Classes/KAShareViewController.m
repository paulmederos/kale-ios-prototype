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

@end

@implementation KAShareViewController

@synthesize mealPhoto;
@synthesize mealTitle;

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
}


- (IBAction)postMeal:(id)sender
{
    NSLog(@"This is where we finish uploading stuff to server!");
    KAMeal *meal = [[KAMeal alloc] init];
    
    meal.title = self.mealTitle.text;
    meal.photoData = UIImageJPEGRepresentation(mealPhoto.image, 0.8f);
    
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    // save it
    [meal saveWithProgress:^(CGFloat progress) {
        hud.progress = progress;
    } completion:^(BOOL success, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
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
    mealTitle.placeholder = @"What are you eating?";
    mealTitle.placeholderTextColor = [UIColor lightGrayColor];
    [mealTitle.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [mealTitle.layer setBorderWidth:1.0f];
    [mealTitle.layer setCornerRadius:2.0f];
    
    [mealPhoto.layer setBorderColor:[UIColor whiteColor].CGColor];
    [mealPhoto.layer setBorderWidth:4.0f];
    [mealPhoto.layer setShadowColor:[UIColor blackColor].CGColor];
    [mealPhoto.layer setShadowOpacity:0.3];
    [mealPhoto.layer setShadowRadius:1.0];
    [mealPhoto.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    
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

#pragma mark - UITextView delegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

@end
