//
//  AuthAPIClient.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "AuthAPIClient.h"
#import "KACredentialStore.h"

#define BASE_URL @"http://kaleweb.herokuapp.com/"

@implementation AuthAPIClient

+ (id)sharedClient {
    static AuthAPIClient *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
        __instance = [[AuthAPIClient alloc] initWithBaseURL:baseUrl];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        self.parameterEncoding = AFJSONParameterEncoding;
        
        [self setAuthTokenHeader];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:@"token-changed"
                                                   object:nil];
    }
    return self;
}

- (void)setAuthTokenHeader {
    KACredentialStore *store = [[KACredentialStore alloc] init];
    NSString *authToken = [store authToken];
    [self setDefaultHeader:@"auth_token" value:authToken];
}

- (void)tokenChanged:(NSNotification *)notification {
    [self setAuthTokenHeader];
}

@end
