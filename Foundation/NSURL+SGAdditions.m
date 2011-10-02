//
//  NSURL+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/1/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSURL+SGAdditions.h"

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
@end
