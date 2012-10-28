//
//  NSData+SGAdditions.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "NSData+SGAdditions.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (SGAdditions)

- (id)initWithBase64String:(NSString *)theString
{
    self = [NSData dataFromBase64String:theString];
    return self;
}

- (NSData *)hmacSHA1DataValueWithKey:(NSData *)keyData;
{
    void* buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA1, [keyData bytes], [keyData length], [self bytes], [self length], buffer);
    return [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}

- (NSString *)UTF8String
{
    return [[NSString alloc] initWithBytes:[self bytes] length:[self length] encoding:NSUTF8StringEncoding];
}

- (NSString *)stringWithHexBytes
{
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([self length] * 2)];
	const unsigned char *dataBuffer = [self bytes];
	int i;
    
	for (i = 0; i < [self length]; ++i)
    {
		[stringBuffer appendFormat:@"%02lx", (unsigned long)dataBuffer[ i ]];
    }
    
	return [stringBuffer copy];
}

- (NSString *)md5
{
	const char *cStr = [self bytes];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (int)[self length], digest );
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
	return s;
}

@end

@implementation NSMutableData (SGAdditions)

- (void)appendUTF8StringWithFormat:(NSString *)inString, ...;
{
    va_list args;
    va_start(args, inString);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:inString arguments:args];
    [self appendUTF8String:formattedString];
    
    va_end(args);
}

- (void)appendUTF8String:(NSString *)string;
{
    [self appendString:string withEncoding:NSUTF8StringEncoding];
}

- (void)appendString:(NSString *)string withEncoding:(NSStringEncoding)inEncoding;
{
    NSUInteger byteLength = [string lengthOfBytesUsingEncoding:inEncoding];
    
    if (!byteLength)
    {
        return;
    }
    
    char *buffer = malloc(byteLength);
    
    BOOL successfullyGotBytes = [string getBytes:buffer maxLength:byteLength usedLength:NULL encoding:inEncoding options:NSStringEncodingConversionExternalRepresentation range:NSMakeRange(0,byteLength) remainingRange:NULL];
    if (successfullyGotBytes == YES)
    {
        [self appendBytes:buffer length:byteLength];
    }
    
    free(buffer);
}

@end
