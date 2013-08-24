//
//  UIDevice+SGExtensions.m
//  SecondGearKit
//
//  Created by Justin Williams on 4/3/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "UIDevice+SGExtensions.h"

@implementation UIDevice (SGExtensions)

- (BOOL)sg_isiPhone
{
    return ([self userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

- (BOOL)sg_isiPad
{
    return ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (NSInteger)sg_majorSystemVersion
{
    return [[[[self systemVersion] componentsSeparatedByString:@"."] firstObject] integerValue];
}

@end
