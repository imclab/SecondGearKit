//
//  NSAlert+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 10/3/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef void (^SGAlertSheetCompletionHandler)(NSAlert *alert, NSInteger returnCode);

@interface NSAlert (SGAdditions)
- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(SGAlertSheetCompletionHandler)completionHandler;
@end
