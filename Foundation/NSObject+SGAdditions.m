//
//  NSObject+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSObject+SGAdditions.h"
#import "NSDate+SGAdditions.h"
#import <objc/runtime.h>

const char *SGAssociatedObjectsDictionaryKey = "SGAssociatedObjectsDictionaryKey";

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

#pragma mark -
#pragma mark Associated Objects
// +--------------------------------------------------------------------
// | Associated Objects
// +--------------------------------------------------------------------

- (void)associateValue:(id)value withKey:(void *)key
{
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weaklyAssociateValue:(id)value withKey:(void *)key
{
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedValueForKey:(void *)key
{
	return objc_getAssociatedObject(self, key);
}

@end
