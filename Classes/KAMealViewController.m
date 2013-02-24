//
//  KAMealViewController.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAMealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "AuthAPIClient.h"
#import "KAComment.h"
#import "MBProgressHUD.h"
#import "KAFeedMealCell.h"

@interface KAMealViewController ()

@end

@implementation KAMealViewController

@synthesize meal, comments, commentsTable, mealPhoto, mealTitle, mealDate, mealUser, mealUserPhoto, commentField, sendCommentButton, commentToolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [commentsTable setDataSource:self];
    [commentsTable setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Set background images/colors
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light_toast.png"]];

    [commentToolbar setBackgroundImage:[UIImage imageNamed:@"comment-background.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [commentField setFrame:CGRectMake(-10.0f, 0, 232.0f, 36.0f)];
    [commentField setDelegate:self];
    [commentField setBackgroundColor:[UIColor whiteColor]];
    [commentField.layer setCornerRadius:4.0f];
    [commentField setTextEdgeInsets:UIEdgeInsetsMake(0, 6.0f, 0, 6.0f)];
    
    
    // Configure outlets
    mealTitle.text = meal.title;
    mealDate.text = meal.eatenAt;
    mealUser.text = meal.ownerUsername;
    [mealPhoto setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:nil];
    [mealUserPhoto setImageWithURL:[NSURL URLWithString:meal.ownerAvatarThumbURL] placeholderImage:nil];
    
    [mealTitle sizeToFit];
    
    [self setBackButton];
    
    NSLog(@"Proud is set to %i", meal.proudOfMeal);
    
    // Load comments
    [self loadComments];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (comments.count > 0){
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:comments.count-1 inSection:0];
        [commentsTable scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

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

- (void)loadComments
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"Comment for Meal ID: %@", meal.serverID);
    
    NSString *url = [NSString stringWithFormat:@"/api/v1/meals/%@/comments", meal.serverID];
    [[AuthAPIClient sharedClient] getPath:url
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"Successful comment GET");
                                      NSMutableArray *results = [NSMutableArray array];
                                      
                                      for (id commentDictionary in responseObject) {
                                          KAComment *comment = [[KAComment alloc] initWithDictionary:commentDictionary];
                                          [results addObject:comment];
                                      }
                                      // Set the array, reload the table
                                      self.comments = results;
                                      [self.commentsTable reloadData];
                                      
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      
                                      // Now scroll to the bottom of table...
                                      if (comments.count > 0) {
                                          NSIndexPath *ipath = [NSIndexPath indexPathForRow:comments.count-1 inSection:0];
                                          [commentsTable scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"%@", error);
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of meals in the array (pulled from the JSON response.)
    return comments.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"comment";
    KAMealCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[KAMealCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:cellIdentifier];
    }
    
    KAComment *comment = [self.comments objectAtIndex:indexPath.row];
    
    cell.commentContent.text = comment.content;
    cell.commentDate.text = comment.createdAt;
    cell.commentOwner.text = comment.ownerUsername;
    [cell.commentOwnerAvatar setImageWithURL:[NSURL URLWithString:comment.ownerAvatarThumbURL] placeholderImage:nil];
    [cell.commentContent sizeToFit];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the current comment
        KAComment *comment = [comments objectAtIndex:indexPath.row];
        
        // Make the POST request
        NSString *url = [NSString stringWithFormat:@"/api/v1/meals/%@/comments/%@", meal.serverID, comment.serverID];
        NSLog(@"URL: %@", url);
        
        // Create JSON hash to send over
        NSDictionary *params = @{
        @"content" : comment.content
        };
        
        // Send the DELETE request
        [[AuthAPIClient sharedClient] deletePath:url
                                      parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSLog(@"Successfully deleted comment.");
                                          [self loadComments];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Failed to Delete comment. Error: %@", error);
                                      }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.commentField resignFirstResponder];	
}


#pragma mark - Keyboard show/hide

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.commentToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0f;
    self.commentToolbar.frame = frame;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.commentToolbar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.commentToolbar.frame = frame;
    
    [UIView commitAnimations];
}

-(void)dismissKeyboard {
    [self.commentField resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)postComment:(id)sender {
    [self.commentField resignFirstResponder];
    
    KAComment *comment = [[KAComment alloc] init];
    
    comment.content = self.commentField.text;
    
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    //make sure none of the parameters are nil, otherwise it will mess up our dictionary
    if (!comment.content) comment.content = @"";
    
    NSDictionary *params = @{
    @"content" : comment.content
    };
    
    // Make the POST request
    NSString *url = [NSString stringWithFormat:@"/api/v1/meals/%@/comments", meal.serverID];
    [[AuthAPIClient sharedClient] postPath:url
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self loadComments];
                                       [self.commentsTable reloadData];
                                       [self.commentField setText:@""];
                                       [self.commentField resignFirstResponder];
                                       
                                       [hud hide:YES];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"Error in posting comment: %@", error);
                                       [hud setLabelText:@"Error :("];
                                       [hud hide:YES afterDelay:2];
                                   }];
}

@end
