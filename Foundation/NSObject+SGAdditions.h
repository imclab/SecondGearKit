//
//  NSObject+SGAdditions.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SGAdditions)
- (NSString *)URLParameterStringValue;

// Old School Associated Objects
- (void)associateValue:(id)value withKey:(void *)key; // strong
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;

@end
