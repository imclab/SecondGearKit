//
//  NSDate+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SGAdditions)

- (NSString *)HTTPTimeZoneHeaderString;
- (NSString *)HTTPTimeZoneHeaderStringForTimeZone:(NSTimeZone *)timeZone;
- (NSString *)ISO8601String;
- (NSString *)ISO8601StringForTimeZone:(NSTimeZone *)timezone;
@end
