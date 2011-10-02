//
//  NSMutableString+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (SGAdditions)
- (void)appendPathComponent:(NSString *)pathComponent;
- (void)appendPathComponent:(NSString *)pathComponent queryString:(NSString *)queryString;
@end
