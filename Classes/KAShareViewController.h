//
//  KAShareViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 12/1/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSToolkit/SSTextView.h>

@interface KAShareViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *mealPhoto;
@property (strong, nonatomic) IBOutlet SSTextView *mealTitle;

@end
