//
//  NSAlert+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 10/3/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSAlert+SGAdditions.h"

@interface SGAlertSheetCompletionHandlerRunner : NSObject
@property (nonatomic, retain) NSAlert *alert;
@property (nonatomic, copy) SGAlertSheetCompletionHandler completionHandler;
@end

@implementation SGAlertSheetCompletionHandlerRunner

@synthesize alert;
@synthesize completionHandler;

- initWithAlert:(NSAlert *)theAlert completionHandler:(SGAlertSheetCompletionHandler)theHandler
{
  if ((self = [super init]))
  {  
    alert = [theAlert retain];
    completionHandler = [theHandler copy];
  }
  
  return self;
}

- (void)dealloc;
{
  [alert release];
  [completionHandler release];
  [super dealloc];
}

- (void)startOnWindow:(NSWindow *)parentWindow;
{
  // We have to live until the callback, but a -retain will annoy clang-sa.
	[self performSelector:@selector(retain)];
  [self.alert beginSheetModalForWindow:parentWindow modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)alertDidEnd:(NSAlert *)theAlert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
{
  NSAssert(theAlert == alert, @"Got a alert different from what I expected -- This should never happen");
  
  // Clean up the hidden -retain from -startOnWindow:, first and with -autorelease in case the block asplodes.
  [self performSelector:@selector(autorelease)];
  
  if (self.completionHandler != nil)
  {
    self.completionHandler(alert, returnCode);
  }
}

@end


@implementation NSAlert (SGAdditions)

- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(SGAlertSheetCompletionHandler)completionHandler;
{
  SGAlertSheetCompletionHandlerRunner *runner = [[SGAlertSheetCompletionHandlerRunner alloc] initWithAlert:self completionHandler:completionHandler];
  [runner startOnWindow:window];
  [runner release];
}

@end
