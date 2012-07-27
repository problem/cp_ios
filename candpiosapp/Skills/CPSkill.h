//
//  CPSkill.h
//  candpiosapp
//
//  Created by Stephen Birarda on 5/24/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPSkill : NSObject

@property NSUInteger skillID;
@property BOOL isVisible;
@property int loveCount;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *rank;

- (CPSkill *)initFromDictionary:(NSDictionary *)skillDict;

@end
