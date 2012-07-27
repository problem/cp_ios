//
//  CPApiClient.m
//  candpiosapp
//
//  Created by Stephen Birarda on 7/26/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import "CPApiClient.h"

@implementation CPApiClient

static AFHTTPClient *sharedClient;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kCandPWebServiceUrl]];
    }
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }  
    
    return self;
}

+ (void)checkInToLocation:(CPVenue *)place
                hoursHere:(int)hoursHere
               statusText:(NSString *)statusText
                isVirtual:(BOOL)isVirtual
              isAutomatic:(BOOL)isAutomatic
          completionBlock:(void (^)(NSDictionary *, NSError *))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSString stringWithFormat:@"%.7lf", place.coordinate.latitude]
                  forKey:@"lat"];
    [parameters setValue:[NSString stringWithFormat:@"%.7lf", place.coordinate.longitude]
                  forKey:@"lng"];
    [parameters setValue:place.name forKey:@"venue_name"];
    [parameters setValue:[NSString stringWithFormat:@"%d", hoursHere] forKey:@"hours_here"];
    [parameters setValue:place.foursquareID forKey:@"foursquare"];
    [parameters setValue:place.address forKey:@"address"];
    [parameters setValue:place.city forKey:@"city"];
    [parameters setValue:place.state forKey:@"state"];
    [parameters setValue:place.zip forKey:@"zip"];
    [parameters setValue:place.phone forKey:@"phone"];
    [parameters setValue:place.formattedPhone forKey:@"formatted_phone"];
    [parameters setValue:[NSString stringWithFormat:@"%d", isAutomatic] forKey:@"is_automatic"];
    [parameters setValue:statusText forKey:@"status"];
    
    if(isVirtual) {
        [parameters setValue:@"1" forKey:@"is_virtual"];
    } else {
        [parameters setValue:@"0" forKey:@"is_virtual"];
        
    }
    
    [parameters setValue:@"checkin" forKey:@"action"];
    
    [sharedClient postPath:@"api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [FlurryAnalytics logEvent:@"checkedIn"];
}



@end
