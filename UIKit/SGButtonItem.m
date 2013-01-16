//
//  SGButtonItem.m
//  PTUtilities
//
//  Created by Justin Williams on 1/2/13.
//  Copyright (c) 2013 Smile Software. All rights reserved.
//

#import "SGButtonItem.h"

@implementation SGButtonItem

+ (instancetype)buttonItem
{
    return [[self alloc] init];
}

+ (instancetype)buttonItemWithLabel:(NSString *)label
{
    SGButtonItem *newItem = [self buttonItem];
    newItem.label = label;
    return newItem;
}

+ (instancetype)buttonItemWithLabel:(NSString *)label action:(SGButtonItemActionBlock)action
{
    SGButtonItem *newItem = [self buttonItem];
    newItem.label = label;
    newItem.action = action;
    
    return newItem;
}

@end
