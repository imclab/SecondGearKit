//
//  UIFont+SGExtensions.m
//  Second Gear Pitbox
//
//  Created by Justin Williams on 6/28/10.
//  Copyright 2010 Second Gear. All rights reserved.
//

#import "UIFont+SGExtensions.h"


@implementation UIFont (SGExtensions)

+ (NSArray *)sortedFamilyNames
{
    return [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

+ (NSArray *)sortedEveryFont
{
    NSArray *familyNames = [UIFont familyNames];
    NSMutableArray *fontArray = [NSMutableArray array];
    
	for (NSString *familyName in familyNames )
    {
		NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
		for (NSString *fontName in fontNames)
        {
			[fontArray addObject:fontName];
		}
	}
    
    return [fontArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
