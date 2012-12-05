//
//  KAMeal.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/21/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAMeal.h"

@implementation KAMeal

@synthesize ownerUsername,
            ownerID,
            ownerAvatarSquareURL,
            ownerAvatarThumbURL,
            title,
            eaten_at,
            photoSquareURL;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.ownerUsername = [dictionary objectForKey:@"owner_username"];
        self.ownerID = [dictionary objectForKey:@"owner_id"];
        self.ownerAvatarSquareURL = [dictionary objectForKey:@"owner_avatar_square"];
        self.ownerAvatarThumbURL = [dictionary objectForKey:@"owner_avatar_thumb"];
        self.title = [dictionary objectForKey:@"title"];
        self.eaten_at = [dictionary objectForKey:@"eaten_at"];
        self.photoSquareURL = [dictionary objectForKey:@"photo"];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
