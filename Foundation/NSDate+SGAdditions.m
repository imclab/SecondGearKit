//
//  NSDate+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSDate+SGAdditions.h"

@implementation NSDate (SGAdditions)

- (NSString *)HTTPTimeZoneHeaderString
{
    return [self HTTPTimeZoneHeaderStringForTimeZone:nil];
}

- (NSString *)HTTPTimeZoneHeaderStringForTimeZone:(NSTimeZone *)theTimeZone
{
    NSTimeZone *timeZone = theTimeZone ? theTimeZone : [NSTimeZone localTimeZone];
    NSString *dateString = [self ISO8601StringForTimeZone:timeZone];
    NSString *timeZoneHeader = [NSString stringWithFormat:@"%@;;%@", dateString, [timeZone name]];
    return timeZoneHeader;
}

- (NSString *)ISO8601String;
{
    return [self ISO8601StringForTimeZone:nil];
}

- (NSString *)ISO8601StringForTimeZone:(NSTimeZone *)timeZone;
{
    if (timeZone == nil)
    {
        timeZone = [NSTimeZone localTimeZone];
    }
    
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = [self timeIntervalSince1970] - [timeZone secondsFromGMT];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%S%z", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
}


@end
