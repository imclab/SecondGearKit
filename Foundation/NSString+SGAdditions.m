//
//  NSString+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSString+SGAdditions.h"

@implementation NSString (SGAdditions)
- (NSString *)stringByEscapingQueryParameters;
{
  // Changed to reflect http://en.wikipedia.org/wiki/Percent-encoding with the addition of the "%"
  return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8);
}

- (NSString *)stringByReplacingPercentEscapes;
{
  return (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL, (__bridge CFStringRef)self, CFSTR(""));
}

@end
