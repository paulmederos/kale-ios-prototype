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
#import "KAProfileCollectionHeaderView.h"
#import "KAMealViewController.h"
#import "KAProfileViewController.h"
#import "KAMainNavigationBar.h"
#import "KASettingsNavigationController.h"

#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"



@interface KAProfileViewController ()
{
    NSUserDefaults *defaults;
    KAProfileCollectionHeaderView *header;
}
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end

@implementation KAProfileViewController

@synthesize userMeals, mealsCollection, pullToRefreshView, user;

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
    
    // Set badge count to 0 (assuming they have checked-in happiness
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUserUpdatedNotification:)
                                                 name:@"UserUpdatedNotification"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserUpdatedNotification" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure instance variables
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (!user) {
        NSLog(@"No user given. Must be My Profile.");
        user = [[KAUser alloc] initWithDictionary:(NSDictionary *)defaults];
    }
    
    [mealsCollection setAllowsSelection:YES];
    [mealsCollection setAllowsMultipleSelection:NO];
    
    // Hook up delegates
    [mealsCollection setDataSource:self];
    [mealsCollection setDelegate:self];
    
    // Set up appearance/interface stuff
    [self customizeAppearance];
    
    NSLog(@"Appearance is set. Time to pull user data.");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self pullUserData];
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc]
                              initWithScrollView:self.mealsCollection
                              delegate:self];
}

- (void)customizeAppearance
{
    
    // Set background images/colors
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0f
                                                green:239.0/255.0f
                                                 blue:233.0/255.0f
                                                alpha:1.0];
    
    if (!user.serverID || user.serverID == [defaults objectForKey:@"serverID"])
    {
        self.navigationItem.rightBarButtonItem = [self setupSettingsButton];
    } else {
        [self setBackButton];
    }
    
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
    NSLog(@"User ID: %@", user.serverID);
    NSString *url = [NSString stringWithFormat:@"/api/v1/users/%@", user.serverID];
    [[AuthAPIClient sharedClient] getPath:url
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"Successfully pulled user data: %@", responseObject);
                                      [user updateFromJSON:responseObject];
                                      [self updateProfileInterface:responseObject];

                                      // Pull meal data
                                      [self updateMealData];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"Error pulling user Personal data: %@", error);
                                  }];
}


- (void)updateProfileInterface:(id)userDictionary
{
    // This should be called after user profile data has been updated and needs UI refresh.
    header.profileUsername.text = user.displayName;
    header.mealsCount.text = user.mealCount;
    header.followersCount.text = user.followersCount;
    header.followingCount.text = user.followingCount;
    [header.profilePhoto setImageWithURL:[NSURL URLWithString:user.avatarThumbURL]];
}

- (void)updateMealData
{
    NSString *url = [NSString stringWithFormat:@"/api/v1/users/%@/meals", user.serverID];
    [[AuthAPIClient sharedClient] getPath:url
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self parseMealsJSON:responseObject];
                                      [self.mealsCollection reloadData];
                                      
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
}


#pragma mark - Notifications
- (void)receiveUserUpdatedNotification:(NSNotification *) notification
{
    NSLog(@"User updated. Lets update UI from NSUserDefaults.");
    [self updateMealData];
}


#pragma mark - Logout / terminate session

- (void)terminateUserSession
{
    KACredentialStore *store = [[KACredentialStore alloc] init];
    [store clearSavedCredentials];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

-(void)showMenuSheet:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:@"Logout"
                        otherButtonTitles:@"Account Settings", nil]
     showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self terminateUserSession]; break;
        case 1:
            [self showAccountView];break;
    }
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return userMeals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"profileMealCell";
    KAMeal *meal = [self.userMeals objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cellImage setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
    
    [cell addSubview:cellImage];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    // Make a KAMealViewController, set the data, push it on the nav controller.
    KAMealViewController *mealViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mealDetail"];
    NSLog(@"Selected cell #%ld", (long)indexPath.row);
    KAMeal *meal = [userMeals objectAtIndex:[indexPath row]];
    [mealViewController setMeal:meal];
    NSLog(@"Selected meal: %@", meal.title);
    
    [colView deselectItemAtIndexPath:indexPath animated:YES];
    [mealViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:mealViewController animated:YES];
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                withReuseIdentifier:@"profileCollectionHeader"
                                                       forIndexPath:indexPath];
    return header;
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

#pragma mark - UINavigationBar backButtonItem

- (void)setBackButton
{
    UIButton *backButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"controls-nav-back-arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 36.0, 18.0f)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
