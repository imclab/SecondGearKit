//
//  NSURL+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/1/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSURL+SGAdditions.h"
#import "NSArray+SGAdditions.h"
#import "NSDictionary+SGAdditions.h"

@implementation NSURL (SGAdditions)

- (NSString *)absoluteStringMinusQueryString
{
  NSMutableString *returnString = [[NSMutableString alloc] init];
  [returnString appendFormat:@"%@://%@", [self scheme], [self host]];
  
  if (self.path != nil) 
  {
    [returnString appendString:self.path];
  }
  
  return returnString;
}

- (NSDictionary *)queryParameters
{
  NSString *query = [self query];
  NSArray *keyValuePairs = [query componentsSeparatedByString:@"&"];
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  for (NSString *pair in keyValuePairs) 
  {
    NSArray *components = [pair componentsSeparatedByString:@"="];
    
    if (components.count == 2) 
    {
      NSString *key = [[components firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      NSString *value = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      
      if (key && value) 
      {
        [params setObject:value forKey:key];
      }
    }
  }
  
  return params;
}

- (NSURL *)URLByAppendingString:(NSString *)theString
{
  NSString *baseURL = [self absoluteString];
  
  if ([baseURL hasSuffix:@"/"] && [theString hasPrefix:@"/"]) 
  {
    theString = [theString substringFromIndex:1];
  } 
  else if (theString.length && ![baseURL hasSuffix:@"/"] && ![theString hasPrefix:@"/"]) 
  {
    // Don't append a trailing / if string is empty.
    theString = [@"/" stringByAppendingString:theString];
  }
  
  return [NSURL URLWithString:[baseURL stringByAppendingString:theString]];
}

- (NSURL *)URLByAppendingQueryParameters:(NSDictionary *)theParameters
{
  if (theParameters.count == 0) 
  {
    return self;
  }
  
  NSMutableString *urlString = [[self absoluteString] mutableCopy];
  
  if ([self query]) 
  {
    [urlString appendString:@"&"];
  } 
  else 
  {
    [urlString appendString:@"?"];
  }
  
  [urlString appendString:[theParameters URLEncodedStringValue]];
  NSURL *returnURL = [NSURL URLWithString:urlString];
  
  return returnURL;
}

@end
