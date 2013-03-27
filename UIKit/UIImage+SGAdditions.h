//
//  UIImage+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 3/23/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SGImageResizeMethod) {
    SGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    SGImageResizeCropStart,
    SGImageResizeCropEnd,
    SGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
};

@interface UIImage (SGAdditions)

- (UIImage *)resizeToDesiredSize:(CGSize)size method:(SGImageResizeMethod)method;

- (UIImage *)resizeToDesiredSize:(CGSize)size;

- (UIImage *)fixOrientation;

@end
