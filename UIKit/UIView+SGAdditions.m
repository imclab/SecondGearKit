//
//  UIView+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 8/24/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "UIView+SGAdditions.h"

@implementation UIView (SGAdditions)

+ (instancetype)autolayoutView
{
    UIView *view = [[self alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
