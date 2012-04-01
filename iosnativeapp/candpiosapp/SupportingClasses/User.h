//
//  User.h
//  candpiosapp
//
//  Created by Stephen Birarda on 2/1/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CPPlace.h"

@interface User : NSObject <NSCoding>

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, assign) BOOL facebookVerified;
@property (nonatomic, assign) BOOL linkedInVerified;
@property (nonatomic, strong) NSString *hourlyRate;
@property (nonatomic, assign) double totalEarned;
@property (nonatomic, assign) double totalSpent;
@property (nonatomic, strong) NSURL *urlPhoto;
@property (nonatomic, strong) NSString *skills;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) BOOL checkedIn;
@property (nonatomic, strong) CPPlace *placeCheckedIn;
@property (nonatomic, strong) NSDate *checkoutEpoch;
@property (nonatomic, strong) NSString *join_date;
@property (nonatomic, assign) int trusted_by;
@property (nonatomic, strong) NSDictionary *listingsAsClient;
@property (nonatomic, readonly) BOOL hasAnyListingsAsClient;
@property (nonatomic, strong) NSDictionary *listingsAsAgent;
@property (nonatomic, readonly) BOOL hasAnyListingsAsAgent;
@property (nonatomic, strong) NSArray *workInformation;
@property (nonatomic, readonly) BOOL hasAnyWorkInformation;
@property (nonatomic, strong) NSArray *educationInformation;
@property (nonatomic, readonly) BOOL hasAnyEducationInformation;
@property (nonatomic, strong) NSDictionary *reviews;
@property (nonatomic, strong) NSMutableArray *checkInHistory;
@property (nonatomic, readonly) NSMutableArray *favoritePlaces;
@property (nonatomic, readonly) BOOL hasAnyFavoritePlaces;

-(void)loadUserResumeData:(void (^)(NSError *error))completion;

-(NSString *)firstName;


@end
