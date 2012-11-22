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


@interface KAFeedTableViewController ()
{
    
}


@end



@implementation KAFeedTableViewController

@synthesize meals;
@synthesize pullToRefreshView;
@synthesize apiURL;

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
    apiURL = [NSURL URLWithString:@"http://kaleweb.herokuapp.com/api/v1/meals"];
    [super viewDidLoad];
    self.pullToRefreshView = [[SSPullToRefreshView alloc]
                              initWithScrollView:self.tableView
                              delegate:self];
    
    [self initialURLRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialURLRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [self getMealsFromURL:apiURL];
}

- (void)getMealsFromURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request,
                                                   NSHTTPURLResponse *response, id json) {
                                             NSMutableArray *results = [NSMutableArray array];
                                             
                                             for (id mealDictionary in json) {
                                                 KAMeal *meal = [[KAMeal alloc] initWithDictionary:mealDictionary];
                                                 [results addObject:meal];
                                             }
                                             
                                             self.meals = results;
                                             [self.tableView reloadData];
                                             
                                             [self.pullToRefreshView finishLoading];
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"%@", error);
                                         }];    
    [operation start];
}

#pragma mark - Pull to Refresh

- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
    return YES;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self getMealsFromURL:apiURL];
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
    static NSString *cellIdentifier = @"mealCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    KAMeal *meal = [self.meals objectAtIndex:indexPath.row];
    cell.textLabel.text = meal.title;
    cell.detailTextLabel.text = meal.eaten_at;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KAMealViewController *mealViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mealDetail"];
    
    KAMeal *meal = [meals objectAtIndex:[indexPath row]];
    [mealViewController setMeal:meal];
    
    [self.navigationController pushViewController:mealViewController animated:YES];
}



@end
