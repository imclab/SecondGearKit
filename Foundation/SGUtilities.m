//
//  SGUtilities.m
//  SecondGearKit
//
//  Created by Justin Williams on 11/30/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "SGUtilities.h"

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