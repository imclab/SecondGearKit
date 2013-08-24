//
//  UITableViewCell+SGExtensions.m
//  SecondGearKit
//
//  Created by Justin Williams on 12/20/12.
//  Copyright (c) 2012 Second Gear LLC. All rights reserved.
//

#import "UITableViewCell+SGExtensions.h"

@implementation UITableViewCell (SGExtensions)

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
