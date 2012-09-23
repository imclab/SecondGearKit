//
//  NSDictionary+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSDictionary+SGAdditions.h"
#import "NSObject+SGAdditions.h"
#import "NSString+SGAdditions.h"

@implementation NSDictionary (SGAdditions)

+ (NSDictionary *)dictionaryWithURLEncodedString:(NSString *)urlEncodedString
{
    NSMutableDictionary *mutableResponseDictionary = [[NSMutableDictionary alloc] init];
    // split string by &s
    NSArray *encodedParameters = [urlEncodedString componentsSeparatedByString:@"&"];
    for (NSString *parameter in encodedParameters)
    {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];
        if (keyValuePair.count == 2)
        {
            NSString *key = [[keyValuePair objectAtIndex:0] stringByReplacingPercentEscapes];
            NSString *value = [[keyValuePair objectAtIndex:1] stringByReplacingPercentEscapes];
            [mutableResponseDictionary setObject:value forKey:key];
        }
    }
    
    return mutableResponseDictionary;
}

- (NSString *)URLEncodedStringValue
{
	if (self.count < 1)
    {
        return @"";
    }
    
	NSEnumerator *keyEnum = [self keyEnumerator];
	NSString *currentKey;
    
	BOOL appendAmpersand = NO;
    
	NSMutableString *parameterString = [[NSMutableString alloc] init];
    
	while ((currentKey = (NSString *)[keyEnum nextObject]) != nil)
    {
		id currentValue = [self objectForKey:currentKey];
		NSString *stringValue = [currentValue URLParameterStringValue];
        
		if (stringValue != nil)
        {
			if (appendAmpersand)
            {
				[parameterString appendString: @"&"];
			}
            
			NSString *escapedStringValue = [stringValue stringByEscapingQueryParameters];
            
			[parameterString appendFormat: @"%@=%@", currentKey, escapedStringValue];
		}
        
		appendAmpersand = YES;
	}
    
	return parameterString;
}

- (NSString *)URLEncodedQuotedKeyValueListValue
{
	if (self.count < 1)
    {
        return @"";
    }
    
	NSEnumerator *keyEnum = [self keyEnumerator];
	NSString *currentKey;
    
	BOOL appendComma = NO;
    
	NSMutableString *listString = [[NSMutableString alloc] init];
    
	while ((currentKey = (NSString *)[keyEnum nextObject]) != nil)
    {
		id currentValue = [self objectForKey:currentKey];
		NSString *stringValue = [currentValue URLParameterStringValue];
        
		if (stringValue != nil)
        {
            if (appendComma)
            {
				[listString appendString: @", "];
			}
            
            // This is super hacky, but basically we don't want to double-encode the oauth_callback value.
            NSString *escapedStringValue = nil;
            if ([currentKey isEqualToString:@"oauth_callback"])
            {
                escapedStringValue = stringValue;
            }
            else
            {
                escapedStringValue = [stringValue stringByEscapingQueryParameters];
            }
            
			[listString appendFormat: @"%@=%\"%@\"", currentKey, escapedStringValue];			
		}
        
		appendComma = YES;
	}
    
	return listString;
}


@end
