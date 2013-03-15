//
//  KASignupViewController.h
//  Kale
//
//  Created by Paul Mederos on 2/7/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <SSToolkit/SSTextField.h>
#import "MBProgressHUD.h"


@interface KASignupViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SSTextField *usernameField;
@property (weak, nonatomic) IBOutlet SSTextField *emailField;
@property (weak, nonatomic) IBOutlet SSTextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;

- (IBAction)validateSignup:(id)sender;

@end
