//
//  NSURL+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 10/1/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SGAdditions)

- (NSString *)absoluteStringMinusQueryString;
- (NSDictionary *)queryParameters;
- (NSURL *)URLByAppendingString:(NSString *)string;
- (NSURL *)URLByAppendingQueryParameters:(NSDictionary *)parameters;

@end
