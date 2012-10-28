//
//  NSString+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SGAdditions)
- (NSString *)stringByEscapingQueryParameters;
- (NSString *)stringByReplacingPercentEscapes;
+ (NSString *)UUIDString;
@end
