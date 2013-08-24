//
//  NSRegularExpression+SGExtensions.h
//  PDFpenOCR
//
//  Created by Justin Williams on 8/21/13.
//  Copyright (c) 2013 SmileOnMyMac LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (SGExtensions)

+ (NSRegularExpression *)sg_fromPattern:(NSString *)pattern;
- (NSArray *)sg_allMatches:(NSString *)stringToMatch;

@end
