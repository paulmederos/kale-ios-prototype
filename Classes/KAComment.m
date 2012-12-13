//
//  KAComment.m
//  kale
//
//  Created by Paul Mederos Jr on 12/9/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAComment.h"
#import "AFNetworking.h"
#import "AuthAPIClient.h"

@implementation KAComment

@synthesize serverID, content, ownerID, ownerUsername, ownerAvatarThumbURL, createdAt;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateFromJSON:dictionary];
    }
    
    return self;
}

- (void)updateFromJSON:(NSDictionary *)dictionary {
    self.serverID = [dictionary objectForKey:@"comment_server_id"];
    self.content = [dictionary objectForKey:@"content"];
    self.ownerID = [dictionary objectForKey:@"owner_id"];
    self.ownerUsername = [dictionary objectForKey:@"owner_username"];
    self.ownerAvatarThumbURL = [dictionary objectForKey:@"owner_thumb_url"];
    self.createdAt = [dictionary objectForKey:@"created_at"];
}


@end
