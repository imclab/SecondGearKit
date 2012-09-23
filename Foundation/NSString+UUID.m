//
//  NSString+UUID.m
//
//  Created by digdog on 9/10/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//
//  https://gist.github.com/574166/2bfcbac77b449530493a4a48c8067e837198f83c

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)UUIDString 
{  
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString *UUIDString = (__bridge NSString*) CFUUIDCreateString(kCFAllocatorDefault, uuid);
	CFRelease(uuid);
  
	return UUIDString;
}

@end
