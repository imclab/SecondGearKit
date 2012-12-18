//
//  SGProgressHUD.h
//  Elements
//
//  Created by Justin Williams on 3/18/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "MBProgressHUD.h"

@interface SGProgressHUD : MBProgressHUD

- (id)init;
+ (SGProgressHUD *)showHUDAnimated:(BOOL)animated;
+ (BOOL)hideHUDAnimated:(BOOL)animated;
+ (void)showSuccessHUD;

@end
