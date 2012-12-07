//
//  KAProfileViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//


#import "AuthAPIClient.h"
#import "KAMeal.h"
#import "KACredentialStore.h"
#import "KAMealViewController.h"
#import "KAProfileMealCell.h"
#import "KAProfileViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"



@interface KAProfileViewController ()
{
    __weak UIBarButtonItem *settingsButton;
}

@end

@implementation KAProfileViewController

@synthesize profilePhoto, userMeals, mealsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAppearance];
    
    [mealsTable setDataSource:self];
    [mealsTable setDelegate:self];
    
    [self pullUserPersonalData];
    [self pullUserMealData];
}

- (void)setupAppearance
{
    // Reset placeholders to nil
    username.text = nil;
    numberOfMeals.text = nil;
    
    // Set background images/colors
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light_toast.png"]];
    
    [profilePhoto.layer setMasksToBounds:YES];
    [profilePhoto.layer setCornerRadius:8.0f];
    [profilePhoto.layer setBorderColor:[UIColor blackColor].CGColor];
    [profilePhoto.layer setBorderWidth:1.0f];
}

- (void)pullUserPersonalData
{    
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self configureProperties:responseObject];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"%@", error);
                                  }];
}

- (void)configureProperties:(id)userDictionary
{
    username.text = [userDictionary objectForKey:@"username"];
    numberOfMeals.text = [NSString stringWithFormat:@"%@ meals shared", [userDictionary objectForKey:@"meals"]];
    [profilePhoto setImageWithURL:[NSURL URLWithString:[userDictionary objectForKey:@"avatar_square"]]];
}

- (void)pullUserMealData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/meals/me"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"Successfully pulled user meals: %@", responseObject);
                                      
                                      [self parseMealsJSON:responseObject];
                                      [self.mealsTable reloadData];
                                      
                                      NSLog(@"Should hide progress HUD now.");
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Error: %@", error);
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }];
}

- (void)parseMealsJSON:(id)responseObject
{
    NSLog(@"Hopping in the parser.");
    NSMutableArray *results = [NSMutableArray array];
    for (id mealDictionary in responseObject) {
        KAMeal *meal = [[KAMeal alloc] initWithDictionary:mealDictionary];
        [results addObject:meal];
    }
    
    NSLog(@"Done parsing.");
    self.userMeals = results;
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self terminateUserSession]; break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Make a KAMealViewController, set the data, push it on the nav controller.
    KAMealViewController *mealViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mealDetail"];
    
    KAMeal *meal = [userMeals objectAtIndex:[indexPath row]];
    [mealViewController setMeal:meal];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:mealViewController animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of meals in the array (pulled from the JSON response.)
    return userMeals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the image from URL, the title, and the eaten_at date... using the profileMealPhoto reuse identifier
    static NSString *cellIdentifier = @"profileMealPhoto";
    KAProfileMealCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[KAProfileMealCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    KAMeal *meal = [self.userMeals objectAtIndex:indexPath.row];
    cell.mealTitle.text = meal.title;
    cell.mealDate.text = meal.eaten_at;
    [cell.mealPhoto setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:nil];
    
    return cell;
}

@end
