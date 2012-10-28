//
//  NSSet+SGExtensions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/17/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSSet+SGExtensions.h"

@implementation NSSet (SGExtensions)


- (id)randomObject
{
    NSArray * allObjects = [self allObjects];
    if ([allObjects count] == 0)
    {
        return nil;
    }
    return allObjects[(arc4random() % [allObjects count])];
}

@end
