//
//  KALoginViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KALoginViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UIButton *loginButton;

}
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;

- (IBAction)openWebsiteSignup:(id)sender;
- (IBAction)openWebsiteResetPassword:(id)sender;

@end
