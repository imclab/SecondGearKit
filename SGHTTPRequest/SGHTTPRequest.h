//
//  SecondGearKit.h
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  SGHTTPRequestMethodGET,
  SGHTTPRequestMethodPOST,
  SGHTTPRequestMethodPUT,
  SGHTTPRequestMethodDELETE,
} SGHTTPRequestMethod;

typedef enum {
  SGHTTPRequestStatusIdle,
  SGHTTPRequestStatusLoading,
  SGHTTPRequestStatusComplete,
  SGHTTPRequestStatusFailed
} SGHTTPRequestStatus;

typedef enum {
  SGHTTPRequestPOSTBodyFormatMultipart,
  SGHTTPRequestPOSTBodyFormatJSON,
  SGHTTPRequestPOSTBodyFormatURLEncoded
} SGHTTPRequestPOSTBodyFormat;

typedef void (^SGHTTPBlock)(void);

@interface SGHTTPRequest : NSOperation

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *APIVersion;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, weak, readonly) NSString *queryString;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) SGHTTPRequestPOSTBodyFormat postBodyFormat;

@property (nonatomic, assign) BOOL requiresOAuthSignature;
@property (nonatomic, strong) NSString *OAuthConsumerKey;
@property (nonatomic, strong) NSString *OAuthSecretKey;
@property (nonatomic, strong) NSString *OAuthToken;
@property (nonatomic, strong) NSString *OAuthTokenSecret;

@property (nonatomic, assign) SGHTTPRequestMethod requestMethod;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong, readonly) NSError *error;
@property (strong) SGHTTPBlock requestDidStartBlock;
@property (strong) SGHTTPBlock requestDidFinishBlock;
@property (strong) SGHTTPBlock requestDidFailBlock; 

@property (nonatomic, readonly) BOOL isLoading;

+ (id)requestWithBaseURL:(NSString *)baseURL;
+ (id)requestWithBaseURL:(NSString *)baseURL method:(NSString *)method;
+ (id)requestWithBaseURL:(NSString *)baseURL APIVersion:(NSString *)version method:(NSString *)method;

- (id)initWithBaseURL:(NSString *)baseURL;
- (id)initWithBaseURL:(NSString *)baseURL method:(NSString *)method;
- (id)initWithBaseURL:(NSString *)baseURL APIVersion:(NSString *)version method:(NSString *)method;

- (void)addQueryParametersFromDictionary:(NSDictionary *)dictionary;
- (void)setQueryParameterValue:(NSString *)parameterValue forKey:(NSString *)key;
- (id)queryParameterValueForKey:(NSString *)key;

- (void)setHeaderString:(NSString *)headerString forKey:(NSString *)key;
- (NSString *)headerStringForKey:(NSString *)key;

- (void)addPostBodyParametersFromDictionary:(NSDictionary *)dictionary;
- (void)setPostBodyParameterValue:(id)parameter forKey:(NSString *)key;
- (id)postBodyParameterValueForKey:(NSString *)key;

- (void)setPostBodyFileData:(NSData *)inData forKey:(NSString *)inKey filename:(NSString *)inFilename contentType:(NSString *)inContentType;
- (void)setPostBodyFilePath:(NSString *)inPath forKey:(NSString *)inKey filename:(NSString *)inFilename contentType:(NSString *)inContentType;
- (NSDictionary *)postBodyFileInfoForKey:(NSString *)inKey;

- (void)addOAuthParametersFromDictionary:(NSDictionary *)dictionary;
- (void)setOAuthParameter:(id)parameter forKey:(NSString *)key;
- (id)OAuthParameterForKey:(NSString *)key;

@end
