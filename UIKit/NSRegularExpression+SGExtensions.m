//
//  NSRegularExpression+SGExtensions.m
//  PDFpenOCR
//
//  Created by Justin Williams on 8/21/13.
//  Copyright (c) 2013 SmileOnMyMac LLC. All rights reserved.
//

#import "NSRegularExpression+SGExtensions.h"

@implementation NSRegularExpression (SGExtensions)

+ (NSRegularExpression *)sg_fromPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (regex == nil)
    {
        NSLog(@"Error generating regex %@", error);
    }
    
    return regex;
}

- (NSArray *)sg_allMatches:(NSString *)stringToMatch
{
    NSRange range = NSMakeRange(0, [stringToMatch length]);
    NSArray *matchesInString = [self matchesInString:stringToMatch options:0 range:range];
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in matchesInString)
    {
        [matches addObject:[stringToMatch substringWithRange:[match range]]];
    }
    
    return matches;
}

@end
