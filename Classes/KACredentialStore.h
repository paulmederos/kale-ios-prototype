//
//  KACredentialStore.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KACredentialStore : NSObject

- (BOOL)isLoggedIn;
- (void)clearSavedCredentials;
- (NSString *)authToken;
- (NSString *)userID;
- (void)setAuthToken:(NSString *)authToken;

@end
