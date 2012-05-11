//
//  VenueChatEntry.m
//  candpiosapp
//
//  Created by Stephen Birarda on 4/16/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import "VenueChatEntry.h"
#import "MapDataSet.h"

@implementation VenueChatEntry

@synthesize entryID = _entryID;
@synthesize user = _user;
@synthesize text = _text;
@synthesize date = _date;
@synthesize delegate = _delegate;

- (VenueChatEntry *)initFromJSON:(NSDictionary *)json dateFormatter:(NSDateFormatter *)dateFormatter
{
    if (self = [super init]) {
        
        // set the basic entry properties
        self.entryID = [[json objectForKey:@"id"] intValue];
        self.text = [json objectForKey:@"entry"];
        
        self.date = [dateFormatter dateFromString:[json objectForKey:@"date"]];
        
        // set the user property
        self.user = [self userFromDictionaryOrActiveUsers:json];
    }
    return self;
}

- (User *)userFromDictionaryOrActiveUsers:(NSDictionary *)userDict
{
    // get the user ID
    NSString *userID = [userDict objectForKey:@"user_id"];
    
    // check if we have this user in the map dataset
    User *entryUser = [[CPAppDelegate settingsMenuController].mapTabController userFromActiveUsers:[userID integerValue]];
    
    if (!entryUser) {
        // we didn't get the user from the activeUsers from the map
        // so we'll make one here
        entryUser = [[User alloc] init];
        entryUser.userID = [userID intValue];
        entryUser.nickname = [userDict objectForKey:@"author"];
        
        NSString *photoString = [userDict objectForKey:@"filename"];
        if (![photoString isKindOfClass:[NSNull class]]) {
            entryUser.urlPhoto = [NSURL URLWithString:photoString];
        }            
    }
    
    return entryUser;
}

// override the isEqual method to be able to tell if we have already added a chat entry
- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if (self.entryID != [other entryID])
        return NO;
    return YES;
}

@end
