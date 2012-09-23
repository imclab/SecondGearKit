//
//  NSMutableString+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSMutableString+SGAdditions.h"

@implementation NSMutableString (SGAdditions)


- (void)appendPathComponent:(NSString *)thePathComponent
{
    [self appendPathComponent:thePathComponent queryString:nil];
}

- (void)appendPathComponent:(NSString *)thePathCompoennt queryString:(NSString *)theQueryString
{
    if ((thePathCompoennt.length == 0) || [thePathCompoennt isEqualToString:@"/"])
    {
        return;
    }
    
    // See if there is already a query string
    NSRange queryRange = [self rangeOfString:@"\?.*" options:NSRegularExpressionSearch];
    if (queryRange.location != NSNotFound)
    {
        // Remove the existing query string, but cache it
        NSString *foundQueryString = [self substringWithRange:queryRange];
        [self deleteCharactersInRange:queryRange];
        
        // If the user passed in a new query string, or we
        // have a query string with only a ?, simply lose
        // the existing query string. Otherwise, append it
        // after the
        if ((foundQueryString.length > 1) && (!theQueryString.length))
        {
            [self appendPathComponent:thePathCompoennt queryString:foundQueryString];
            return;
        }
    }
    
    if ((self.length == 0) || [self hasSuffix:@"/"])
    {
        [self appendString:thePathCompoennt];
    }
    else
    {
        [self appendFormat:@"/%@", thePathCompoennt];
    }
    
    if (theQueryString.length)
    {
        [self appendString:theQueryString];
    }
}


@end
