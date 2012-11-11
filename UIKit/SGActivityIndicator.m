//
//  SGActivityIndicator.m
//  Second Gear Pitbox
//
//  Created by Justin Williams on 4/10/10.
//  Copyright 2010 w. All rights reserved.
//

#import "SGActivityIndicator.h"

static NSInteger count = 0;

@implementation SGActivityIndicator

+ (void)enable
{
    count++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
}

+ (void)disable
{
    count--;
    if (count <= 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        count = 0;
    }  
}

@end
