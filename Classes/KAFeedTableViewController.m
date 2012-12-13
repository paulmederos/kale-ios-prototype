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

@property (strong, nonatomic) UIImagePickerController *pickerController;

@end



@implementation KAFeedTableViewController

@synthesize meals, pullToRefreshView, pickerController;

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
                                                                       action:@selector(takePhoto:)];
    self.navigationItem.rightBarButtonItem = shareMealButton;
    [self initialDataRequest];
}

-(void)initialDataRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Meals";
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
                                      NSLog(@"");
                                      
                                  }];
}

- (void)takePhoto:(id)sender {
    pickerController  = [[UIImagePickerController alloc] init];
    // If we have a camera, take a picture. If not, use Photo Library.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.navigationItem.title = @"Camera";
    
    [self presentViewController:pickerController animated:NO completion:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Canceled the camera action.");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // First, initialize and push shareViewController on UIImageController
    // (which is a subclass of UInavigationController)
    UIStoryboard *storyboard = self.storyboard;
    KAShareViewController *shareViewController = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    // Then push on to the stack.
    [pickerController pushViewController:shareViewController animated:YES];
    [shareViewController.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Next, Pass the image reference
    [shareViewController.mealPhoto setImage:editedPhoto];
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
    KAMeal *meal = [self.meals objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"mealCell";
    KAFeedMealCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[KAFeedMealCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    }
    
    cell.mealTitle.text = meal.title;
    cell.mealDate.text = meal.eatenAt;
    cell.mealUser.text = meal.ownerUsername;
    [cell.mealPhoto setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:nil];
    [cell.mealUserPhoto setImageWithURL:[NSURL URLWithString:meal.ownerAvatarThumbURL] placeholderImage:nil];

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

@end
