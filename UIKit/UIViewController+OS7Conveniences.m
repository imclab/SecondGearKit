//
//  UIViewController+OS7Conveniences.m
//  PDFpenOCR
//
//  Created by Justin Williams on 8/20/13.
//  Copyright (c) 2013 SmileOnMyMac LLC. All rights reserved.
//

#import "UIViewController+OS7Conveniences.h"
#import "UIDevice+SGExtensions.h"

@implementation UIViewController (OS7Conveniences)

- (void)sg_hideStatusBarOniOS7
{
    if ([[UIDevice currentDevice] sg_majorSystemVersion] >= 7)
    {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
