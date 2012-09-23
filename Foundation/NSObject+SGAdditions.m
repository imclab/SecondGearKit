//
//  NSObject+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSObject+SGAdditions.h"
#import "NSDate+SGAdditions.h"

@implementation NSObject (SGAdditions)

- (NSString *)URLParameterStringValue
{
	NSString *stringValue = nil;
    
	if ([self isKindOfClass: [NSString class]])
    {
		stringValue = (NSString *)self;
	}
	else if ([self isKindOfClass: [NSNumber class]])
    {
		stringValue = [(NSNumber *)self stringValue];
	}
	else if ([self isKindOfClass: [NSDate class]])
    {
		stringValue = [(NSDate *)self HTTPTimeZoneHeaderString];
	}
    
	return stringValue;
}


@end
