//
//  UIDevice+SGExtensions.h
//  SecondGearKit
//
//  Created by Justin Williams on 4/3/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SGExtensions)

- (BOOL)sg_isiPhone;
- (BOOL)sg_isiPad;
- (NSInteger)sg_majorSystemVersion;

@end
