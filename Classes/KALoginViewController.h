//
//  KAWelcomeViewController.h
//  Kale
//
//  Created by Paul Mederos on 2/22/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSTextField.h>

@interface KALoginViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet SSTextField *emailField;
@property (weak, nonatomic) IBOutlet SSTextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;

@end
