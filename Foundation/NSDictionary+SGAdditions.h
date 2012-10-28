//
//  NSDictionary+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SGAdditions)

+ (NSDictionary *)dictionaryParsedFromURLEncodedString:(NSString *)urlEncodedString;
- (NSString *)URLEncodedStringValue;
- (NSString *)URLEncodedQuotedKeyValueListValue;

@end
