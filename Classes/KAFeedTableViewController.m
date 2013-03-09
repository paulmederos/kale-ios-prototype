//
//  KAFeedTableViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "AFNetworking.h"
#import "AuthAPIClient.h"
#import "MBProgressHUD.h"

#import "KAFeedMealCell.h"
#import "KAFeedTableViewController.h"
#import "KAMainNavigationBar.h"
#import "KAMeal.h"
#import "KAMealViewController.h"
#import "KAShareViewController.h"



@interface KAFeedTableViewController ()

@end



@implementation KAFeedTableViewController

@synthesize meals, pullToRefreshView;

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
    self.pullToRefreshView = [[SSPullToRefreshView alloc]
                              initWithScrollView:self.tableView
                              delegate:self];
    
    self.navigationItem.rightBarButtonItem = [self logMealButton];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0f green:239.0/255.0f blue:233.0/255.0f alpha:1.0];
    
    [self initialDataRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMealPostedNotification:)
                                                 name:@"MealPostedNotification"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MealPostedNotification" object:nil];
}

- (UIBarButtonItem *)logMealButton {
    UIImage *logMealImage = [UIImage imageNamed:@"nav-log_meal-button.png"];
    UIImage *logMealPressed = [UIImage imageNamed:@"nav-log_meal-button-pressed.png"];
    UIButton *logMealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [logMealButton setBackgroundImage:logMealImage forState:UIControlStateNormal];
    [logMealButton setBackgroundImage:logMealPressed forState:UIControlStateHighlighted];
    
    const CGFloat BarButtonOffset = 5.0f;
    [logMealButton setFrame:CGRectMake(BarButtonOffset, 0, logMealImage.size.width, logMealImage.size.height)];

    // Set target and action (this way since it has a custom view, cant set on UIBarButtonItem)
    [logMealButton addTarget:self action:@selector(recordMeal:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logMealImage.size.width, logMealImage.size.height)];
    [containerView addSubview:logMealButton];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return item;
}

-(void)initialDataRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Meals.";
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(cancelHud:)]];
    [self getMeals];
}

- (void)getMeals {
    [[AuthAPIClient sharedClient] getPath:@"/api/v1/meals"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSMutableArray *results = [NSMutableArray array];
                                      
                                      for (id mealDictionary in responseObject) {
                                          KAMeal *meal = [[KAMeal alloc] initWithDictionary:mealDictionary];
                                          [results addObject:meal];
                                      }
                                      
                                      self.meals = results;
                                      [self.tableView reloadData];
                                      
                                      [self.pullToRefreshView finishLoading];
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];

                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"%@", error);
                                  }];
}

- (void)recordMeal:(id)sender
{
    NSLog(@"Record meal action.");
    KAShareViewController *svc =  [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    
    [svc setHidesBottomBarWhenPushed:YES];
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)cancelHud {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


#pragma mark - UINavigationController delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Use custom nav bar UI for sharing
    [navigationController setValue:[[KAMainNavigationBar alloc] init]
                                         forKeyPath:@"navigationBar"];
    [navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Pull to Refresh

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return YES;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self getMeals];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.meals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the meal for this specific cell
    KAMeal *meal = [self.meals objectAtIndex:indexPath.row];
    
    // Set the cellIdentifier and retrieve a used cell (if it exists)
    static NSString *cellIdentifier = @"mealCell";
    KAFeedMealCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[KAFeedMealCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    }
    
    // Set the image, text, and appearance
    [cell prepareWithMeal:meal];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KAMealViewController *mealViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mealDetail"];
    
    KAMeal *meal = [meals objectAtIndex:[indexPath row]];
    [mealViewController setMeal:meal];
    
    [mealViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:mealViewController animated:YES];
}

#pragma mark - Notifications

- (void)receiveMealPostedNotification:(NSNotification *) notification
{
    NSLog(@"Meal was just posted - lets fetch new data.");
//    [self scheduleHappinessCheck];
    [self initialDataRequest];
}


// We want to see how people are feeling after thier meals
// so we can let them know what sorts of foods make them
// feel better.
// This function schedules a local notification and prompts
// the user to pick Happy / OK / Bad for how they feel, and
// then records this on the server.
- (void)scheduleHappinessCheck
{
    NSLog(@"Scheduling happiness check.");
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Set the action button
    localNotif.alertAction = @"View";
    localNotif.alertBody = @"How do you feel after that meal an hour ago?";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber += 1;
    
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
    
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];    
}

@end
