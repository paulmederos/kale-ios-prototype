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
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *ownerAvatarSquareURL;
@property (nonatomic, copy) NSString *ownerAvatarThumbURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *eaten_at;
@property (nonatomic, copy) NSString *photoSquareURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
