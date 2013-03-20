//
//  KAMeal.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/21/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAMeal : NSObject

@property (nonatomic, copy) NSString *ownerUsername;
@property (nonatomic, copy) NSString *ownerDisplayName;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *ownerAvatarSquareURL;
@property (nonatomic, copy) NSString *ownerAvatarThumbURL;
@property (nonatomic, copy) NSString *photoSquareURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *eatenAt;
@property (nonatomic, copy) NSString *eatenDay;
@property (nonatomic, copy) NSString *eatenMonth;
@property (nonatomic, copy) NSString *eatenYear;
@property (nonatomic, copy) NSString *serverID;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSData *photoData;
@property (nonatomic) BOOL proudOfMeal;


- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock;

@end
