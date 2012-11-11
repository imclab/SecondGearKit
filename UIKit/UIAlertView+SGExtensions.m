//
//  UIAlertView+SGExtensions.m
//  Second Gear Pitbox
//
//  Created by Justin Williams on 3/15/10.
//  Copyright 2010 Second Gear. All rights reserved.
//

#import "UIAlertView+SGExtensions.h"

void UIAlertViewQuick(NSString* title, NSString* message, NSString* dismissButtonTitle) {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:dismissButtonTitle
                                          otherButtonTitles:nil
                          ];
	[alert show];
}

@implementation UIAlertView (SGExtensions)

@end
