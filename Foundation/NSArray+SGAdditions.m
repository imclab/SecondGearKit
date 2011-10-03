//
//  NSArray+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/3/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSArray+SGAdditions.h"

@implementation NSArray (SGAdditions)

- (id)firstObject
{
  return self.count > 0 ? [self objectAtIndex:0] : nil;
}

@end
