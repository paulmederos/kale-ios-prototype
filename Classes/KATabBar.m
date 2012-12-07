//
//  KATabBar.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KATabBar.h"

@implementation KATabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}

- (void)customize
{
    UIImage *tabBarBG = [UIImage imageNamed:@"tabbar-background.png"];
    UIImage *tabBarSelected = [UIImage imageNamed:@"tabbar-background-pressed.png"];
    [self setBackgroundImage:tabBarBG];
    [self setSelectionIndicatorImage:tabBarSelected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
