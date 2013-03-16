//
//  KAProfileViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//


#import "AuthAPIClient.h"

#import "KAAccountViewController.h"
#import "KAMeal.h"
#import "KACredentialStore.h"
#import "KAMealViewController.h"
#import "KAProfileMealCell.h"
#import "KAProfileViewController.h"
#import "KAMainNavigationBar.h"
#import "KASettingsNavigationController.h"

#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"



@interface KAProfileViewController ()
{
    NSUserDefaults *defaults;
}
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end

@implementation KAProfileViewController

@synthesize profilePhoto, userMeals, mealsTable, lastMealPhoto, pullToRefreshView;

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
    [super viewWillAppear:animated];
    
    float yOffset = 200.0f; // size of Profile area.
    mealsTable.frame =  CGRectMake(mealsTable.frame.origin.x, mealsTable.frame.origin.y - yOffset, mealsTable.frame.size.width, mealsTable.frame.size.height);
    
    // Set badge count to 0 (assuming they have checked-in happiness
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    
    [mealsTable setDataSource:self];
    [mealsTable setDelegate:self];
    
    [self setupAppearance];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self pullUserData];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc]
                              initWithScrollView:self.mealsTable
                              delegate:self];
}

- (void)setupAppearance
{
    // Reset placeholders to nil
    username.text = nil;
    numberOfMeals.text = nil;
    
    [profileContainer.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profileContainer.layer setBorderWidth:1.0f];
    
    // Set background images/colors
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0f
                                                green:239.0/255.0f
                                                 blue:233.0/255.0f
                                                alpha:1.0];
    
    // Bring profile photo to front of the profile pic    
    [profilePhoto.layer setMasksToBounds:YES];
    [profilePhoto.layer setCornerRadius:8.0f];
    [profilePhoto.layer setBorderColor:[UIColor blackColor].CGColor];
    [profilePhoto.layer setBorderWidth:1.0f];
    [profilePhoto.layer setShadowColor:[UIColor whiteColor].CGColor];
    [profilePhoto.layer setShadowOffset:CGSizeMake(0,0)];
    [profilePhoto.layer setShadowOpacity:1];
    [profilePhoto.layer setShadowRadius:2.0];
    
    // Set placeholders while content loads
    [profilePhoto setImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
    
    [mealsTable bringSubviewToFront:profilePhoto];
    
    self.navigationItem.rightBarButtonItem = [self setupSettingsButton];
}

- (UIBarButtonItem *)setupSettingsButton {
    UIImage *settingsCogImage = [UIImage imageNamed:@"nav-settings.png"];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [settingsButton setBackgroundImage:settingsCogImage forState:UIControlStateNormal];
    
    const CGFloat BarButtonOffset = 0.0f;
    [settingsButton setFrame:CGRectMake(BarButtonOffset, 0, settingsCogImage.size.width, settingsCogImage.size.height)];
    
    // Set target and action (this way since it has a custom view, cant set on UIBarButtonItem)
    [settingsButton addTarget:self action:@selector(showMenuSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, settingsCogImage.size.width, settingsCogImage.size.height)];
    [containerView addSubview:settingsButton];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return item;
}

// Only need to call pullUserData to refresh profile
- (void)pullUserData
{
    // First, pull profile details (name, meal count, etc.)
    // then once completed, pull Meals details
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self configureProperties:responseObject];

                                      // Pull meal data
                                      [self pullUserMealData];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Error pulling user Personal data: %@", error);
                                  }];
}

- (void)configureProperties:(id)userDictionary
{
    // Set NSUserDefaults first
    [self configureUserDefaults:userDictionary];
    
    // Then set interface pieces
    username.text = [defaults objectForKey:@"username"];
    numberOfMeals.text = [NSString stringWithFormat:@"%@ meals shared", [defaults objectForKey:@"mealsCount"]];
    [profilePhoto setImageWithURL:[NSURL URLWithString:[defaults objectForKey:@"avatar_square"]]];
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

- (void)pullUserMealData
{
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/meals/me"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self parseMealsJSON:responseObject];
                                      [self.mealsTable reloadData];
                                      
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [self.pullToRefreshView finishLoading];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Error pulling user Meals data: %@", error);
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [self.pullToRefreshView finishLoading];
                                  }];
}

- (void)parseMealsJSON:(id)responseObject
{
    NSMutableArray *results = [NSMutableArray array];
    for (id mealDictionary in responseObject) {
        KAMeal *meal = [[KAMeal alloc] initWithDictionary:mealDictionary];
        [results addObject:meal];
    }
    
    self.userMeals = results;
}


#pragma mark - Logout / terminate session

-(void)showMenuSheet:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:@"Logout"
                        otherButtonTitles:@"View Webapp", @"Settings", nil]
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
        case 1:
            [self openWebsiteAccountDetails:nil]; break;
        case 2:
            [self showAccountView];break;
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
    [mealViewController setHidesBottomBarWhenPushed:YES];
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
    cell.mealDay.text = meal.eatenDay;
    cell.mealMonth.text = meal.eatenMonth;
    cell.mealYear.text = meal.eatenYear;
    [cell.mealPhoto setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:nil];
    
    return cell;
}

- (void)openWebsiteAccountDetails:(id)sender
{
    NSString* launchUrl = @"https://kaleweb.herokuapp.com/account-details";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (void)showAccountView
{
    KASettingsNavigationController *snvc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsNavigationViewController"];
    [snvc setDelegate:self];
    [self presentViewController:snvc animated:YES completion:nil];
//    KAAccountViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"accountViewController"];
//    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - Pull to Refresh

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return YES;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self pullUserData];
}

#pragma mark - UINavigationController delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Use custom nav bar UI for sharing
    [navigationController setValue:[[KAMainNavigationBar alloc] init]
                        forKeyPath:@"navigationBar"];
    [navigationController setNavigationBarHidden:NO animated:YES];
}


@end
