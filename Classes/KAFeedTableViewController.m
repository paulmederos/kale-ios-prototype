//
//  KAFeedTableViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAFeedTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KAMeal.h"
#import "KAMealViewController.h"
#import "AuthAPIClient.h"
#import "KAShareViewController.h"
#import "KAMainNavigationBar.h"
#import "KAFeedMealCell.h"

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
    UIBarButtonItem *shareMealButton = [[UIBarButtonItem alloc] initWithTitle:@"Record"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(recordMeal:)];
    self.navigationItem.rightBarButtonItem = shareMealButton;
    [self.view.layer setBackgroundColor:[UIColor colorWithRed:234.0/255.0f
                                                        green:229.0/255.0f
                                                         blue:224.0/255.0f
                                                        alpha:1.0].CGColor];
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
    KAShareViewController *svc =  [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    
    [svc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:svc animated:YES];
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

- (void) receiveMealPostedNotification:(NSNotification *) notification
{
    NSLog(@"Meal was just posted - lets fetch new data.");
    [self initialDataRequest];
}

@end
