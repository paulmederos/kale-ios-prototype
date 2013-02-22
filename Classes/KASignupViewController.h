//
//  KASignupViewController.h
//  Kale
//
//  Created by Paul Mederos on 2/7/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface KASignupViewController : UIViewController <MBProgressHUDDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *signupWebView;

@end
