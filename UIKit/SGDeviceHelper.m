//
//  SGDeviceHelper.m
//  Second Gear Pitbox
//
//  Created by Justin Williams on 3/15/10.
//  Copyright 2010 w. All rights reserved.
//

#import "SGDeviceHelper.h"

extern BOOL DeviceIsPad(void)
{
    if (([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]))
	{
        return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
	}
    
    return NO;
}

extern BOOL SGIsMultitaskingSupported(void)
{
	return [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported];
}

