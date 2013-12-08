//
//  SGUtilities.m
//  SecondGearKit
//
//  Created by Justin Williams on 11/30/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "SGUtilities.h"

BOOL SGIsEmpty(id obj)
{
	return obj == nil || obj == [NSNull null] || ([obj respondsToSelector:@selector(length)] && [(NSData *)obj length] == 0) || ([obj respondsToSelector:@selector(count)] && [obj count] == 0);
}


NSString * SGApplicationName(void)
{
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    return applicationInfo[@"CFBundleName"];
}

extern NSString * SGApplicationVersion(void)
{
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    return applicationInfo[@"CFBundleShortVersionString"];
}

NSString * SGApplicationBuildNumber(void)
{
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    return applicationInfo[@"CFBundleVersion"];
}