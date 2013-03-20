//
//  KAMeal.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/21/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAMeal.h"
#import "AFNetworking.h"
#import "AuthAPIClient.h"
#import "KANotifications.h"

@implementation KAMeal

@synthesize ownerUsername,
            ownerDisplayName,
            ownerID,
            ownerAvatarSquareURL,
            ownerAvatarThumbURL,
            photoSquareURL,
            title,
            eatenAt,
            eatenDay,
            eatenMonth,
            eatenYear,
            serverID,
            photoData,
            commentCount,
            proudOfMeal;

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

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    //make sure none of the parameters are nil, otherwise it will mess up our dictionary
    if (!self.title) self.title = @"";
    NSLog(@"About to save.");
    
    NSDictionary *params = @{
        @"meal[title]" : self.title,
        @"meal[proud]" : [NSNumber numberWithBool:self.proudOfMeal],
    };
    
    NSURLRequest *postRequest = [[AuthAPIClient sharedClient]
                                multipartFormRequestWithMethod:@"POST"
                                path:@"/api/v1/meals"
                                parameters:params
                                constructingBodyWithBlock:^(id formData) {
                                    NSLog(@"Sending data.");
                                    [formData appendPartWithFileData:self.photoData
                                                                 name:@"meal[photo]"
                                                             fileName:@"meal.jpg"
                                                             mimeType:@"image/jpg"];

                                }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    NSLog(@"Creating operation.");
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            NSDictionary *updatedMeal = [responseObject objectForKey:@"meal"];
            [self updateFromJSON:updatedMeal];
            [self notifyCreated];
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
    [[AuthAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
}

- (void)updateFromJSON:(NSDictionary *)dictionary {
    self.ownerUsername = [dictionary objectForKey:@"owner_username"];
    self.ownerDisplayName = [dictionary objectForKey:@"owner_name"];
    self.ownerID = [dictionary objectForKey:@"owner_id"];
    self.ownerAvatarSquareURL = [dictionary objectForKey:@"owner_avatar_square"];
    self.ownerAvatarThumbURL = [dictionary objectForKey:@"owner_avatar_thumb"];
    self.title = [dictionary objectForKey:@"title"];
    self.eatenAt = [dictionary objectForKey:@"eaten_at"];
    self.eatenDay = [dictionary objectForKey:@"eaten_at_day"];
    self.eatenMonth = [dictionary objectForKey:@"eaten_at_month"];
    self.eatenYear = [dictionary objectForKey:@"eaten_at_year"];
    self.photoSquareURL = [dictionary objectForKey:@"photo"];
    self.serverID = [dictionary objectForKey:@"meal_server_id"];
    self.commentCount = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"comments_count"]];
    self.proudOfMeal = [dictionary objectForKey:@"proud"];
}

- (void)notifyCreated {
    [[NSNotificationCenter defaultCenter] postNotificationName:KAMealCreatedNotification
                                                        object:self];
}


@end
