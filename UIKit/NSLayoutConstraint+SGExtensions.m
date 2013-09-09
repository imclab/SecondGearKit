//
//  NSLayoutConstraint+SGExtensions.m
//  Animations
//
//  Created by Justin Williams on 9/5/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "NSLayoutConstraint+SGExtensions.h"

@implementation NSLayoutConstraint (SGExtensions)

#ifdef DEBUG

- (NSString *)sg_description
{
    // Swizzle this instead so you don't lose the good idea.
    // There's a private method to override.
    NSString *description = [self description];
    
    return [description stringByAppendingFormat:@"(%@, %@)",
            [self.firstItem restorationIdentifier],
            [self.secondItem restorationIdentifier]];
}

#endif


@end
