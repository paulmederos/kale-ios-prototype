//
//  KAShareViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 12/1/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAShareViewController.h"
#import "KAMainNavigationBar.h"

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


- (IBAction)shareMeal:(id)sender
{
    NSLog(@"This is where we finish uploading stuff to server!");
}

- (void)customizeAppearance
{
    // Set the title
    self.navigationItem.title = @"Share Food";
    
    // Set background colors/images
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light_toast.png"]];
    
    mealTitle.backgroundColor = [UIColor whiteColor];
    mealTitle.placeholder = @"What are you eating?";
    mealTitle.placeholderTextColor = [UIColor lightGrayColor];
    
    // Set navigation button styles / actions
    UIBarButtonItem *shareMealButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(shareMeal:)];
    self.navigationItem.rightBarButtonItem = shareMealButton;
}


@end
