//
//  UIApplication+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/28/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "UIApplication+SGAdditions.h"

@implementation UIApplication (SGAdditions)

+ (CGSize)currentSize
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    return [UIApplication sizeInOrientation:orientation];
}

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    
    return size;
}

@end
