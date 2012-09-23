//
//  NSAlert+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/3/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSAlert+SGAdditions.h"

@interface SGAlertSheetCompletionHandlerRunner : NSObject
@property (nonatomic, strong) NSAlert *alert;
@property (nonatomic, copy) SGAlertSheetCompletionHandler completionHandler;
@end

@implementation SGAlertSheetCompletionHandlerRunner

- initWithAlert:(NSAlert *)theAlert completionHandler:(SGAlertSheetCompletionHandler)theHandler
{
  if ((self = [super init]))
  {  
    _alert = [theAlert retain];
    _completionHandler = [theHandler copy];
  }
  
  return self;
}

- (void)startOnWindow:(NSWindow *)parentWindow;
{
  [self.alert beginSheetModalForWindow:parentWindow modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)alertDidEnd:(NSAlert *)theAlert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
{
  NSAssert(theAlert == self.alert, @"Got a alert different from what I expected -- This should never happen");

  if (self.completionHandler != nil)
  {
    self.completionHandler(self.alert, returnCode);
  }
}

@end


@implementation NSAlert (SGAdditions)

- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(SGAlertSheetCompletionHandler)completionHandler;
{
  SGAlertSheetCompletionHandlerRunner *runner = [[SGAlertSheetCompletionHandlerRunner alloc] initWithAlert:self completionHandler:completionHandler];
  [runner startOnWindow:window];
}

@end
