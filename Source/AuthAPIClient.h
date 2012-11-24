//
//  AuthAPIClient.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "AFNetworking.h"

@interface AuthAPIClient : AFHTTPClient

+ (id)sharedClient;

@end
