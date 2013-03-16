//
//  KAAccountViewController.h
//  Kale
//
//  Created by Paul Mederos on 3/14/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAAccountViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (void)saveSettings:(id)selector;

@end
