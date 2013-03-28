//
//  UIImage+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 3/23/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "UIImage+SGAdditions.h"

@implementation UIImage (SGAdditions)

- (UIImage *)resizeToDesiredSize:(CGSize)desiredSize
{
    return [self resizeToDesiredSize:desiredSize method:SGImageResizeScale];
}

- (UIImage *)resizeToDesiredSize:(CGSize)desiredSize method:(SGImageResizeMethod)resizeMethod
{
    CGFloat imageScale = self.scale;
    CGFloat sourceWidth = self.size.width * imageScale;
	CGFloat sourceHeight = self.size.height * imageScale;
	CGFloat targetWidth = desiredSize.width;
	CGFloat targetHeight = desiredSize.height;
    BOOL cropping = (resizeMethod != SGImageResizeScale);
        
	// Calculate aspect ratios
	CGFloat sourceRatio = sourceWidth / sourceHeight;
	CGFloat targetRatio = targetWidth / targetHeight;
    
	// Determine what side of the source image to use for proportional scaling
	BOOL scaleWidth = (sourceRatio <= targetRatio);
	// Deal with the case of just scaling proportionally to fit, without cropping
	scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
	// Proportionally scale source image
	float scalingFactor, scaledWidth, scaledHeight;
	if (scaleWidth == YES)
    {
		scalingFactor = 1.0 / sourceRatio;
		scaledWidth = targetWidth;
		scaledHeight = round(targetWidth * scalingFactor);
	}
    else
    {
		scalingFactor = sourceRatio;
		scaledWidth = round(targetHeight * scalingFactor);
		scaledHeight = targetHeight;
	}
    CGFloat scaleFactor = scaledHeight / sourceHeight;

    CGRect sourceRect = CGRectZero;
    CGRect destRect = CGRectZero;
    if (cropping == YES)
    {
        destRect = CGRectMake(0, 0, targetWidth, targetHeight);
		CGFloat destX = 0.0f;
        CGFloat destY = 0.0f;
		if (resizeMethod == SGImageResizeCrop)
        {
			// Crop center
			destX = round((scaledWidth - targetWidth) / 2.0f);
			destY = round((scaledHeight - targetHeight) / 2.0f);
		}
        else if (resizeMethod == SGImageResizeCropStart)
        {
			// Crop top or left (prefer top)
			if (scaleWidth)
            {
				// Crop top
				destX = 0.0f;
				destY = 0.0f;
			}
            else
            {
				// Crop left
				destX = 0.0f;
				destY = round((scaledHeight - targetHeight) / 2.0f);
			}
		}
        else if (resizeMethod == SGImageResizeCropEnd)
        {
			// Crop bottom or right
			if (scaleWidth)
            {
				// Crop bottom
				destX = round((scaledWidth - targetWidth) / 2.0f);
				destY = round(scaledHeight - targetHeight);
			}
            else
            {
				// Crop right
				destX = round(scaledWidth - targetWidth);
				destY = round((scaledHeight - targetHeight) / 2.0f);
			}
		}
        
		sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor,
								targetWidth / scaleFactor, targetHeight / scaleFactor);

    }
    else
    {
        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
        destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
    }
    
    
    // Create appropriately modified image.
    UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 0.f); // 0.f for scale means "scale for device's main screen".
    CGImageRef sourceImg = CGImageCreateWithImageInRect(self.CGImage, sourceRect); // cropping happens here.
    UIImage *outputImage = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:self.imageOrientation]; // create cropped UIImage.
    
	CGImageRelease(sourceImg);
	[outputImage drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
	outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return outputImage;

}

@end
