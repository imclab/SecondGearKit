//
//  NSData+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"

@interface NSData (SGAdditions)
- (id)initWithBase64String:(NSString *)string;

- (NSData *)hmacSHA1DataValueWithKey:(NSData *)keyData;
- (NSString *)UTF8String;

@end

@interface NSMutableData (SGAdditions)

- (void)appendUTF8String:(NSString *)inString;
- (void)appendUTF8StringWithFormat:(NSString *)inString, ...;
- (void)appendString:(NSString *)inString withEncoding:(NSStringEncoding)inEncoding;

@end
