//
//  KAUser.m
//  Kale
//
//  Created by Paul Mederos on 3/19/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KAUser.h"

@implementation KAUser

@synthesize serverID, displayName, username, email, goal, location, avatarSquareData, avatarThumbData, avatarSquareURL, avatarThumbURL, mealCount, followingCount, followersCount;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateFromJSON:dictionary];
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

- (void)updateFromJSON:(NSDictionary *)dictionary {
    
    // Pulled from Server (hash has 'id') vs pulled from NSUserDefaults (hash has 'serverID')
    if ([dictionary objectForKey:@"id"]) {
        self.serverID = [dictionary objectForKey:@"id"];
    } else {
        self.serverID = [dictionary objectForKey:@"serverID"];
    }
    
    self.avatarSquareURL = [dictionary objectForKey:@"avatar_square"];
    self.avatarThumbURL = [dictionary objectForKey:@"avatar_thumb"];
    self.username = [dictionary objectForKey:@"username"];
    self.displayName = [dictionary objectForKey:@"name"];
    self.email = [dictionary objectForKey:@"email"];
    self.goal = [dictionary objectForKey:@"goal"];
    self.location = [dictionary objectForKey:@"location"];
    self.mealCount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"meals"]];
    self.followersCount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"followers"]];
    self.followingCount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"following"]];
}

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
}

@end
