//
//  KAComment.h
//  kale
//
//  Created by Paul Mederos Jr on 12/9/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAComment : NSObject

//:content => self.content,
//:owner_id => self.user_id,
//:owner_username => @owner.username,
//:owner_thumb_url => @owner.avatar.url(:thumb),
//:created_at => self.created_at,
//:comment_server_id => self.id

@property (nonatomic, copy) NSString *serverID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *ownerUsername;
@property (nonatomic, copy) NSString *ownerAvatarThumbURL;
@property (nonatomic, copy) NSString *createdAt;


- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
