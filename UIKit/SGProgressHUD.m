//
//  SGProgressHUD.m
//  Elements
//
//  Created by Justin Williams on 3/18/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "SGProgressHUD.h"

@implementation SGProgressHUD


- (id)init
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self = [super initWithView:window];
    if (self)
    {
        self.labelFont = [UIFont boldSystemFontOfSize:16.0];
        self.detailsLabelFont = [UIFont boldSystemFontOfSize:12.0];
    }
    
    return self;
}

- (id)initWithWindow:(UIWindow *)window
{
    return [self init];
}

- (id)initWithView:(UIView *)view
{
    return [self init];
}

+ (SGProgressHUD *)showHUDAnimated:(BOOL)animated
{
    SGProgressHUD *hud = [[SGProgressHUD alloc] init];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:hud];
    [hud show:animated];
    return hud;
}

+ (BOOL)hideHUDAnimated:(BOOL)animated
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return [super hideHUDForView:window animated:animated];
}

+ (void)showSuccessHUD
{
    SGProgressHUD *hud = [[SGProgressHUD alloc] init];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"Success", @"");
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:NO];
    [hud hide:YES afterDelay:1.0];
}

@end
