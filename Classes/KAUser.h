//
//  KAUser.h
//  Kale
//
//  Created by Paul Mederos on 3/19/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAUser : NSObject

@property (nonatomic, copy) NSString *serverID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *goal;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *avatarThumbURL;
@property (nonatomic, copy) NSString *avatarSquareURL;
@property (nonatomic, copy) NSString *mealCount;
@property (nonatomic, copy) NSString *followersCount;
@property (nonatomic, copy) NSString *followingCount;

@property (nonatomic, copy) NSData *avatarThumbData;
@property (nonatomic, copy) NSData *avatarSquareData;



- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;
- (void)updateFromJSON:(NSDictionary *)dictionary;


@end
