//
//  SGActivityIndicator.h
//  Second Gear Pitbox
//
//  Created by Justin Williams on 5/17/10.
//  Copyright 2010 w. All rights reserved.
//
//  Helper class to keep track of active network connections and update the device's activity indicator


#import <Foundation/Foundation.h>


@interface SGActivityIndicator : NSObject {}

+ (void)enable;
+ (void)disable;

@end
