//
//  UICollectionViewCell+SGExtensions.m
//  SecondGearKit
//
//  Created by Justin Williams on 12/4/12.
//  Copyright (c) 2012 Second Gear LLC. All rights reserved.
//

#import "UICollectionViewCell+SGExtensions.h"

@implementation UICollectionViewCell (SGExtensions)

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
