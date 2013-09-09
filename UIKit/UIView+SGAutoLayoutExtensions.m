//
//  UIView+SGAutoLayoutExtensions.m
//  Animations
//
//  Created by Justin Williams on 9/5/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "UIView+SGAutoLayoutExtensions.h"
#import "NSLayoutConstraint+SGExtensions.h"

@implementation UIView (SGAutoLayoutExtensions)

#ifdef DEBUG

- (NSString *)nsli_description {
    return [self restorationIdentifier] ?: [NSString stringWithFormat:@"%@:%p", [self class], self];
}

- (BOOL)nsli_descriptionIncludesPointer {
    return [self restorationIdentifier] == nil;
}

- (NSString *)sg_description
{
    // Evil!
    NSString *string = [self performSelector:@selector(nsli_description)];
    
    if (self.restorationIdentifier != nil)
    {
        return [string stringByAppendingFormat:@" (%@)", self.restorationIdentifier];
    }
    
    return string;
}
#endif

@end
