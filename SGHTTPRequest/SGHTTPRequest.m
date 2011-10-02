//
//  SecondGearKit.m
//  SecondGearKit
//
//  Created by Justin Williams on 9/27/11.
//  Copyright (c) 2011 Second Gear. All rights reserved.
//

#import "SGHTTPRequest.h"
#import "NSString+SGAdditions.h"
#import "NSMutableString+SGAdditions.h"
#import "NSDictionary+SGAdditions.h"
#import "NSString+UUID.h"
#import "NSData+SGAdditions.h"
#import "NSDate+SGAdditions.h"
#import "NSURL+SGAdditions.h"

NSString * const SGHTTPRequestContentTypeHeaderKey = @"Content-Type";
NSString * const SGHTTPRequestAuthorizationHeaderKey = @"Authorization";


NSString * const SGHTTPRequestJSONContentType = @"application/json";
NSString * const SGHTTPRequestTextPlainContentType = @"text/plain";
NSString * const SGHTTPRequestTextHTMLContentType = @"text/html";
NSString * const SGHTTPRequestURLEncodedContentType = @"application/x-www-form-urlencoded";
NSString * const SGHTTPRequestMultipartContentType = @"multipart/form-data; boundary=\"%@\"";

NSString * const SGHTTPRequestMultipartBoundaryString = @" ---SGHTTPREQUEST---SGHTTPREQUEST---";

NSString *SGHTTPRequestFileInfoFilenameKey = @"SGHTTPRequestFileInfoFilenameKey";
NSString *SGHTTPRequestFileInfoFileDataKey = @"SGHTTPRequestFileInfoFileDataKey";
NSString *SGHTTPRequestFileInfoFilePathKey = @"SGHTTPRequestFileInfoFilePathKey";
NSString *SGHTTPRequestFileInfoContentTypeKey = @"SGHTTPRequestFileInfoContentTypeKey";

NSString * const SGHTTPRequestOAuthConsumerKeyKey = @"oauth_consumer_key";
NSString * const SGHTTPRequestOAuthVersionKey = @"oauth_version";
NSString * const SGHTTPRequestOAuthTimestampKey = @"oauth_timestamp";
NSString * const SGHTTPRequestOauthNonceKey = @"oauth_nonce";
NSString * const SGHTTPRequestOAuthSignatureMethodKey = @"oauth_signature_method";
NSString * const SGHTTPRequestOAuthSignatureKey = @"oauth_signature";
NSString * const SGHTTPRequestOAuthTokenKey = @"oauth_token";
NSString * const SGHTTPRequestOAuthTokenSecretKey = @"oauth_token_secret";

const NSTimeInterval SGHTTPRequestDefaultTimeoutInterval = 20.0;

@interface SGHTTPRequest ()
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSMutableDictionary *queryParameters;
@property (nonatomic, strong) NSMutableDictionary *postBodyParameters;
@property (nonatomic, strong) NSMutableDictionary *postBodyFiles;
@property (nonatomic, strong) NSData *postBodyData;
@property (nonatomic, strong) NSMutableDictionary *additionalOAuthParameters;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, assign) NSInteger responseStatusCode;
@property (nonatomic, strong) NSString *responseMIMEType;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) id responseJSONObject;
@property (nonatomic, strong) NSJSONSerialization *responseJSONDecoder;
@property (nonatomic, strong) NSString *responseString;
@property (nonatomic, strong) NSDictionary *responseURLEncodedDictionary;
@property (nonatomic, assign) CGFloat responsePercentComplete;
@property (nonatomic, assign) SGHTTPRequestStatus loadingStatus;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isCancelled;

- (void)updateURL;
- (void)handleResponseData;
- (NSString *)generateOAuthAuthorizationHeaderString;
- (NSString *)stringValueForParameterObject:(NSString *)object;
- (NSString *)requestMethodStringForRequestMethod:(SGHTTPRequestMethod)method;
- (NSData *)multipartFormPostBodyData;
- (NSData *)JSONPostBodyData;
- (NSData *)URLEncodedPostBodyData;
- (void)finishExecuting;
- (void)requestFinishedWithGreatSuccess;
- (void)requestFailedWithError:(NSError *)error;
@end

@implementation SGHTTPRequest

@synthesize URL;
@synthesize baseURL;
@synthesize APIVersion;
@synthesize method;
@synthesize queryString;
@synthesize identifier;
@synthesize postBodyFormat;
@synthesize postBodyFiles;
@synthesize requestMethod;
@synthesize requiresOAuthSignature;
@synthesize OAuthConsumerKey;
@synthesize OAuthSecretKey;
@synthesize OAuthToken;
@synthesize OAuthTokenSecret;
@synthesize timeoutInterval;
@synthesize requestDidStartBlock;
@synthesize requestDidFinishBlock;
@synthesize requestDidFailBlock; 
@synthesize isLoading;
@synthesize headers;
@synthesize queryParameters;
@synthesize postBodyParameters;
@synthesize postBodyData;
@synthesize additionalOAuthParameters;
@synthesize connection;
@synthesize response;
@synthesize responseStatusCode;
@synthesize responseMIMEType;
@synthesize responseData;
@synthesize responseJSONObject;
@synthesize responseJSONDecoder;
@synthesize responseString;
@synthesize responseURLEncodedDictionary;
@synthesize responsePercentComplete;
@synthesize loadingStatus;
@synthesize error;
@synthesize isFinished;
@synthesize isExecuting;
@synthesize isCancelled;

+ (id)requestWithBaseURL:(NSString *)theBaseURL
{
  return [[self alloc] initWithBaseURL:theBaseURL method:nil];
}

+ (id)requestWithBaseURL:(NSString *)theBaseURL method:(NSString *)theMethod
{
  return [[self alloc] initWithBaseURL:theBaseURL method:theMethod];
}

+ (id)requestWithBaseURL:(NSString *)theBaseURL APIVersion:(NSString *)theVersion method:(NSString *)theMethod
{
  return [[self alloc] initWithBaseURL:theBaseURL APIVersion:theVersion method:theMethod];
}

#pragma mark -
#pragma mark Initialization Methods
// +--------------------------------------------------------------------
// | Initialization Methods
// +--------------------------------------------------------------------

- (id)initWithBaseURL:(NSString *)theBaseURL
{
  return [self initWithBaseURL:theBaseURL APIVersion:nil method:nil];
}

- (id)initWithBaseURL:(NSString *)theBaseURL method:(NSString *)theMethod
{
  return [self initWithBaseURL:theBaseURL APIVersion:nil method:theMethod];
}

- (id)initWithBaseURL:(NSString *)theBaseURL APIVersion:(NSString *)theVersion method:(NSString *)theMethod
{
  if ((self = [super init]))
  {
    self.requestMethod = SGHTTPRequestMethodGET;
    self.postBodyFormat = SGHTTPRequestPOSTBodyFormatMultipart;
    self.loadingStatus = SGHTTPRequestStatusIdle;
    self.responseStatusCode = 0;

    self.requiresOAuthSignature = NO;
    
    self.baseURL = theBaseURL;
    self.APIVersion = theVersion;
    self.method = theMethod;
    
    self.identifier = [NSString UUIDString];
    self.timeoutInterval = SGHTTPRequestDefaultTimeoutInterval;
    
    self.isFinished = NO;
    self.isExecuting = NO;
    self.isCancelled = NO;
  }
  
  return self;

}

#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)addQueryParametersFromDictionary:(NSDictionary *)theDictionary
{
  if ((theDictionary.count == 0) || self.isLoading)
  {
    return;
  }
  
  [self.queryParameters addEntriesFromDictionary:theDictionary];
  [self updateURL];
}

- (void)setQueryParameterValue:(NSString *)theParameterValue forKey:(NSString *)theKey
{
  if ((theParameterValue == nil) || (theKey.length == 0) || self.isLoading) 
  {
    return;
  }
  
  [self.queryParameters setObject:theParameterValue forKey:theKey];
  [self updateURL];
}


- (id)queryParameterValueForKey:(NSString *)theKey
{
  return [self.queryParameters objectForKey:theKey];
}


- (void)setHeaderString:(NSString *)theHeaderString forKey:(NSString *)theKey
{
  if ((theHeaderString.length == 0) || (theKey.length == 0)) 
  {
    return;
  }
  
  [self.headers setObject:theHeaderString forKey:theKey];

}

- (NSString *)headerStringForKey:(NSString *)theKey
{
  return [self.headers objectForKey:theKey];
}

- (void)addPostBodyParametersFromDictionary:(NSDictionary *)theDictionary;
{
  if ((theDictionary.count == 0) || self.isLoading) 
  {
    return;
  }
  
  [self.postBodyParameters addEntriesFromDictionary:theDictionary];
}

- (void)setPostBodyParameterValue:(id)theParameter forKey:(NSString *)theKey;
{
  if ((theParameter == nil) || (theKey.length == 0) || self.isLoading) 
  {
    return;
  }
  
  [self.postBodyParameters setObject:theParameter forKey:theKey];
}

- (id)postBodyParameterValueForKey:(NSString *)theKey;
{
  return [self.postBodyParameters objectForKey:theKey];
}

- (void)setPostBodyFileData:(NSData *)inData forKey:(NSString *)inKey filename:(NSString *)inFilename contentType:(NSString *)inContentType;
{
  if ((inData.length == 0) || (inKey.length == 0) || (inContentType.length == 0) || self.isLoading) 
  {
    return;
  }
  
  if (inFilename == nil) 
  {
    inFilename = inKey;
  }
  
  NSDictionary *fileInfo = [[NSDictionary alloc] initWithObjectsAndKeys:inData, SGHTTPRequestFileInfoFileDataKey, inFilename, SGHTTPRequestFileInfoFilenameKey, inContentType, SGHTTPRequestFileInfoContentTypeKey, nil];
  [self.postBodyFiles setObject:fileInfo forKey:inKey];
}

- (void)setPostBodyFilePath:(NSString *)inPath forKey:(NSString *)inKey filename:(NSString *)inFilename contentType:(NSString *)inContentType;
{
  if ((inPath.length == 0) || (inKey.length == 0) || (inContentType.length == 0) || self.isLoading) 
  {
    return;
  }
  
  if (inFilename == nil) 
  {
    inFilename = [inPath lastPathComponent];
  }
  
  NSDictionary *fileInfo = [[NSDictionary alloc] initWithObjectsAndKeys:inPath, SGHTTPRequestFileInfoFilePathKey, inFilename, SGHTTPRequestFileInfoFilenameKey, inContentType, SGHTTPRequestFileInfoContentTypeKey, nil];
  [self.postBodyFiles setObject:fileInfo forKey:inKey];
}

- (NSDictionary *)postBodyFileInfoForKey:(NSString *)theKey
{
  return [self.postBodyFiles objectForKey:theKey];
}


- (void)addOAuthParametersFromDictionary:(NSDictionary *)theDictionary
{
  if ((theDictionary.count == 0) || self.isLoading) 
  {
    return;
  }
  
  [self.additionalOAuthParameters addEntriesFromDictionary:theDictionary];
}

- (void)setOAuthParameter:(id)theParameter forKey:(NSString *)theKey
{
  if ((theParameter == nil) || (theKey.length == 0) || self.isLoading) 
  {
    return;
  }
  
  [self.additionalOAuthParameters setObject:theParameter forKey:theKey];
}

- (id)OAuthParameterForKey:(NSString *)theKey
{
  return [self.additionalOAuthParameters objectForKey:theKey];
}



#pragma mark -
#pragma mark NSObject Overrides
// +--------------------------------------------------------------------
// | NSObject Overrides
// +--------------------------------------------------------------------

- (BOOL)isEqual:(id)obj
{
  // If they are literally the same object pointer-wise,
  // simply return YES.
  if ([super isEqual:obj])
  {
    return YES;
  }
  
  BOOL equal = NO;
  
  if ([obj isKindOfClass:[SGHTTPRequest class]]) 
  {
    equal = [((SGHTTPRequest *) obj).identifier isEqualToString:self.identifier];
  }
  
  return equal;
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"<%@: %p (base URL: %@; method: %@; identifier: %@)>\nQuery Parameters%@\nPost Parameters: %@\nHeaders: %@", NSStringFromClass([self class]), self, self.baseURL, self.method, self.identifier, self.queryParameters, self.postBodyParameters, self.headers];
}

#pragma mark -
#pragma mark NSOperation Overrides
// +--------------------------------------------------------------------
// | NSOperation Overrides
// +--------------------------------------------------------------------

- (void)start
{
  if ((self.isCancelled) || (self.isFinished)) 
  {
    return;
  }
  
  if ([NSThread isMainThread] == NO)
  {
    [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
    return;
  }
  
  NSURL *requestURL = self.URL;
  
  if (requestURL == nil)
  {
    // TODO: Fail With Error
  }
  
  
  if (self.requiresOAuthSignature) 
  {
    NSString *OAuthSignature = [self generateOAuthAuthorizationHeaderString];
    
    if (OAuthSignature.length == 0) 
    {
      return;
    }
    
    [self setHeaderString:OAuthSignature forKey:SGHTTPRequestAuthorizationHeaderKey];
  }

  
  [self willChangeValueForKey:@"isExecuting"];
  self.isExecuting = YES;
  [self didChangeValueForKey:@"isExecuting"];

  self.loadingStatus = SGHTTPRequestStatusLoading;
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:self.timeoutInterval];
  request.HTTPMethod = [self requestMethodStringForRequestMethod:self.requestMethod];

  // Process the user-specified headers
  NSArray *headerKeys = [self.headers allKeys];
  
  for (NSString *currentKey in headerKeys) 
  {
    NSString *currentValue = [self.headers objectForKey:currentKey];
    [request addValue:currentValue forHTTPHeaderField:currentKey];
  }
  
  // Set the content type and body if it's a POST request
  if ((self.requestMethod == SGHTTPRequestMethodPOST) && (self.postBodyParameters.count > 0))
  {
    NSString *contentType = nil;
    
    switch (self.postBodyFormat) 
    {
      case SGHTTPRequestPOSTBodyFormatURLEncoded:
        contentType = SGHTTPRequestURLEncodedContentType;
        break;
      case SGHTTPRequestPOSTBodyFormatJSON:
        contentType = SGHTTPRequestJSONContentType;
        break;
      case SGHTTPRequestPOSTBodyFormatMultipart:
        contentType = [NSString stringWithFormat:SGHTTPRequestMultipartContentType, SGHTTPRequestMultipartBoundaryString];
        break;
      default:
        contentType = [NSString stringWithFormat:SGHTTPRequestMultipartContentType, SGHTTPRequestMultipartBoundaryString];
        break;
    }
    
    [request addValue:contentType forHTTPHeaderField:SGHTTPRequestContentTypeHeaderKey];        
    [request setHTTPBody:self.postBodyData];
  }
  
  self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
  
  if (self.requestDidStartBlock != nil) 
  {
    self.requestDidStartBlock();
  }
}

- (void)cancel
{
  @synchronized(self) 
  {
    if (self.isCancelled) 
    {
      return; // Already canceled
    }
    
    [self willChangeValueForKey:@"isCancelled"];
    self.isCancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];

    [self finishExecuting];
    
    [self.connection cancel];	
    [super cancel];
  }
}

- (BOOL)isConcurrent
{
  return YES;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Methods
// +--------------------------------------------------------------------
// | NSURLConnectionDelegate Methods
// +--------------------------------------------------------------------

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)theResponse 
{
  self.response = (NSHTTPURLResponse *)theResponse;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)theData 
{
  self.responsePercentComplete = (theData.length / [self.response expectedContentLength]);
  [self.responseData appendData:theData];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)theError 
{
  [self requestFailedWithError:theError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{  
  [self requestFinishedWithGreatSuccess];
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (void)setBaseURL:(NSString *)theBaseURL
{
  if (self.isLoading) 
  {
    return;
  }
  
  baseURL = theBaseURL;
  
  [self updateURL];
}

- (void)setAPIVersion:(NSString *)theVersion
{
  if (self.isLoading) 
  {
    return;
  }
  
  APIVersion = theVersion;
  
  [self updateURL];
}


- (void)setMethod:(NSString *)theMethod
{
  if (self.isLoading) 
  {
    return;
  }
  
  method = theMethod;
  
  [self updateURL];
}


- (NSMutableDictionary *)headers
{
  if (headers == nil) 
  {
    headers = [[NSMutableDictionary alloc] init];
  }    
  
  return headers;
}


- (NSMutableDictionary *)queryParameters
{
  if (queryParameters == nil)  
  {
    queryParameters = [[NSMutableDictionary alloc] init];
  }
  
  return queryParameters;
}

- (NSMutableDictionary *)postBodyParameters;
{
  if (postBodyParameters == nil) 
  {
    postBodyParameters = [[NSMutableDictionary alloc] init];
  }
  
  return postBodyParameters;
}

- (NSMutableDictionary *)postBodyFiles;
{
  if (postBodyFiles == nil) 
  {
    postBodyFiles = [[NSMutableDictionary alloc] init];
  }
  
  return postBodyFiles;
}

- (NSMutableDictionary *)additionalOAuthParameters;
{
  if (additionalOAuthParameters == nil) 
  {
    additionalOAuthParameters = [[NSMutableDictionary alloc] init];
  }
  
  return additionalOAuthParameters;
}


- (NSString *)queryString
{
  return [self.queryParameters URLEncodedStringValue];
}

- (void)setResponse:(NSHTTPURLResponse *)theResponse;
{
  response = theResponse;
  
  if (theResponse != nil) 
  {
    self.responseStatusCode = theResponse.statusCode;
    self.responseMIMEType = theResponse.MIMEType;
  }
}
  
- (NSData *)postBodyData
{
  if ((self.postBodyParameters == nil) || (self.postBodyFiles == nil)) 
  {
    return nil;
  }
  
  switch (self.postBodyFormat) 
  {
    case SGHTTPRequestPOSTBodyFormatURLEncoded:
      return [self URLEncodedPostBodyData];
      break;
    case SGHTTPRequestPOSTBodyFormatJSON:
      return [self JSONPostBodyData];
      break;
    case SGHTTPRequestPOSTBodyFormatMultipart:
      return [self multipartFormPostBodyData];
      break;
    default:
      return [self multipartFormPostBodyData];
      break;
  }
}

- (void)setRequestMethod:(SGHTTPRequestMethod)theRequestMethod
{
  if (self.isLoading) 
  {
    return;
  }
  
  requestMethod = theRequestMethod;
  
  [self updateURL];
}

- (NSMutableData *)responseData;
{
  if (responseData == nil) 
  {
    responseData = [[NSMutableData alloc] init];
  }
  
  return responseData;
}

- (BOOL)isLoading
{
  return (self.loadingStatus == SGHTTPRequestStatusLoading);
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------


- (void)updateURL
{
  if (self.baseURL.length == 0) 
  {
    self.URL = nil;
    return;
  }
  
  NSMutableString *URLString = [[NSMutableString alloc] init];
  [URLString appendString:self.baseURL];
  [URLString appendPathComponent:self.APIVersion];
  [URLString appendPathComponent:self.method];
  
  if (self.queryString.length != 0) 
  {
    [URLString appendFormat:@"?%@", self.queryString];
  }
  
  self.URL = [NSURL URLWithString:URLString];
}

- (NSString *)requestMethodStringForRequestMethod:(SGHTTPRequestMethod)theRequestMethod
{
  NSString *requestMethodString = @"GET";
  
  switch (theRequestMethod) 
  {
    case SGHTTPRequestMethodPOST:
      requestMethodString = @"POST";
      break;
    case SGHTTPRequestMethodPUT:
      requestMethodString = @"PUT";
      break;
    case SGHTTPRequestMethodDELETE:
      requestMethodString = @"DELETE";
      break;
    default:
      break;
  }
  
  return requestMethodString;
}


- (NSString *)generateOAuthAuthorizationHeaderString
{
  if ((self.OAuthSecretKey.length == 0) || (self.OAuthConsumerKey.length == 0))
  {
    return nil;
  }
  
  NSMutableDictionary *signatureParameterDictionary = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *headerParameterDictionary = [[NSMutableDictionary alloc] init];
  
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
  // Add the standard boilerplate parameters common to all OAuth requests to the header parameters
  [headerParameterDictionary setObject:[NSString stringWithFormat:@"%d", (int)now] forKey:SGHTTPRequestOAuthTimestampKey];
  [headerParameterDictionary setObject:self.identifier forKey:SGHTTPRequestOauthNonceKey];
  [headerParameterDictionary setObject:@"1.0" forKey:SGHTTPRequestOAuthVersionKey];
  [headerParameterDictionary setObject:@"HMAC-SHA1" forKey:SGHTTPRequestOAuthSignatureMethodKey];
  [headerParameterDictionary setObject:self.OAuthConsumerKey forKey:SGHTTPRequestOAuthConsumerKeyKey];
  
  if (self.OAuthToken != nil) 
  {
    [headerParameterDictionary setObject:self.OAuthToken forKey:SGHTTPRequestOAuthTokenKey];
  }
  
  // Add in any additionally specified OAuth parameters to the header parameters
  if (self.additionalOAuthParameters.count > 0) 
  {
    [self.additionalOAuthParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      [headerParameterDictionary setObject:[obj stringByEscapingQueryParameters] forKey:key];
    }];
    
//    [headerParameterDictionary addEntriesFromDictionary:self.additionalOAuthParameters];  
  }
  
  // Mix the header parameters into the signature parameter dictionary
  [signatureParameterDictionary addEntriesFromDictionary:headerParameterDictionary];
  
  if (self.queryParameters.count > 0) 
  {
    [signatureParameterDictionary addEntriesFromDictionary:self.queryParameters];
  }
  
  // Add any POST body parameters to the signature dictionary, but only as long as the 
  // post body format is URL encoded.
  if (self.postBodyParameters.count && self.postBodyFormat == SGHTTPRequestPOSTBodyFormatURLEncoded) 
  {
    // The post parameter values need to be double percent encodeded
    for (NSString *currentPostBodyKey in [self.postBodyParameters allKeys]) 
    {
      NSString *currentPostBodyValue = [self.postBodyParameters objectForKey:currentPostBodyKey];
      [signatureParameterDictionary setObject:[currentPostBodyValue stringByEscapingQueryParameters] forKey:currentPostBodyKey];
    }
  }
  
  // Start the raw signature string
  NSMutableString *rawSignatureString = [[NSMutableString alloc] init];
  
  [rawSignatureString appendFormat:@"%@&%@&", [self requestMethodStringForRequestMethod:self.requestMethod], [[self.URL absoluteStringMinusQueryString] stringByEscapingQueryParameters]];
  
  NSArray *parameterKeys = [[signatureParameterDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  id lastElement = [parameterKeys lastObject];
  for (NSString *currentKey in parameterKeys) 
  {
    id currentValue = [signatureParameterDictionary objectForKey:currentKey];
    NSMutableString *parameterString = [[NSMutableString alloc] init];
    [parameterString appendFormat:@"%@=%@", currentKey, currentValue];
    
    if (currentKey != lastElement) 
    {
      [parameterString appendString:@"&"];
    }
    
    [rawSignatureString appendString:[parameterString stringByEscapingQueryParameters]];
  }
  
  // Hash the raw signature string into an encrypted signature
  NSString *keyString = [NSString stringWithFormat:@"%@&", self.OAuthSecretKey];
  if (self.OAuthTokenSecret != nil) 
  {
    keyString = [keyString stringByAppendingString:self.OAuthTokenSecret];
  }
  
  NSString *encryptedSignatureString = [[[rawSignatureString dataUsingEncoding:NSUTF8StringEncoding] hmacSHA1DataValueWithKey:[keyString dataUsingEncoding:NSUTF8StringEncoding]] base64EncodedString];
  
  // Add the encrypted signature to the header parameter dictionary
  [headerParameterDictionary setObject:encryptedSignatureString forKey:SGHTTPRequestOAuthSignatureKey];
  
  // Turn the header parameter dictionary into a string
  NSString *authorizationHeaderString = [NSString stringWithFormat:@"OAuth %@", [headerParameterDictionary URLEncodedQuotedKeyValueListValue]];
  
  return authorizationHeaderString;
}

- (NSString *)stringValueForParameterObject:(NSString *)inObject
{
  NSString *stringValue = nil;
  
	if ([inObject isKindOfClass:[NSString class]]) {
		stringValue = (NSString *)inObject;
	}
	else if ([inObject isKindOfClass:[NSNumber class]]) {		
		stringValue = [(NSNumber *)inObject stringValue];
	}
	else if ([self isKindOfClass:[NSDate class]]) {
		stringValue = [(NSDate *)inObject HTTPTimeZoneHeaderString];
	}
  
	return stringValue;
}

- (void)handleResponseData
{
  if ((self.response == nil) || (self.responseData.length == 0)) 
  {
    // TODO: Error if no response
    return;
  }
  
  BOOL isJSON = [self.responseMIMEType isEqualToString:SGHTTPRequestJSONContentType];
  BOOL isTextHTML = [self.responseMIMEType isEqualToString:SGHTTPRequestTextHTMLContentType];
  BOOL isTextPlain = [self.responseMIMEType isEqualToString:SGHTTPRequestTextPlainContentType];
  BOOL isURLEncoded = [self.responseMIMEType isEqualToString:SGHTTPRequestURLEncodedContentType];
  if (isJSON) 
  {
    id responseObject = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];
    self.responseJSONObject = responseObject;
  } 
  else if (isTextHTML || isTextPlain) 
  {
    self.responseString = [self.responseData UTF8String];
  } 
  else if (isURLEncoded) 
  {
    self.responseURLEncodedDictionary = [NSDictionary dictionaryWithURLEncodedString:[self.responseData UTF8String]];
  }
}

- (NSData *)multipartFormPostBodyData
{
  if (self.postBodyParameters.count == 0) 
  {
    return nil;
  }
  
  NSMutableData *postData = [[NSMutableData alloc] init];
  
  NSString *startItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", SGHTTPRequestMultipartBoundaryString];
  
  NSUInteger parameterIndex = 0;
  NSArray *postKeys = [self.postBodyParameters allKeys];
  for (id currentKey in postKeys) 
  {
    id currentObject = [self.postBodyParameters objectForKey:currentKey];
    NSString *parameterValue = [self stringValueForParameterObject:currentObject];
    
    if (!parameterValue.length) 
    {
      continue;
    }
    
    // Append the start item boundary
    [postData appendUTF8String:startItemBoundary];
    
    // Append the content disposition
    [postData appendUTF8StringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", currentKey];
    
    // Append the parameter string
    [postData appendUTF8String:parameterValue];
    
    // Append the end item boundary, but only if this 
    // isn't the last item.
    parameterIndex++;
    if (parameterIndex > self.postBodyParameters.count || self.postBodyFiles.count) {
      [postData appendUTF8String:startItemBoundary];
    } 
  }
  
  NSUInteger fileIndex = 0;
  for (NSString *currentFileKey in self.postBodyFiles) 
  {
    NSDictionary *currentFileInfo = [self postBodyFileInfoForKey:currentFileKey];
    NSString *filename = [currentFileInfo objectForKey:SGHTTPRequestFileInfoFilenameKey];
    NSData *fileData = [currentFileInfo objectForKey:SGHTTPRequestFileInfoFileDataKey];
    NSString *filePath = [currentFileInfo objectForKey:SGHTTPRequestFileInfoFilePathKey];
    NSString *contentType = [currentFileInfo objectForKey:SGHTTPRequestFileInfoContentTypeKey];
    
    if (filePath.length && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) 
    {
      fileData = [NSData dataWithContentsOfFile:filePath];
    }
    
    if (fileData.length == 0) 
    {
      continue;
    }
    
    [postData appendUTF8StringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", currentFileKey, filename];
    [postData appendUTF8StringWithFormat:@"Content-Type: %@\r\n\r\n", contentType];
    
    // Append the file data
    [postData appendData:fileData];
    
    // Append the end item boundary, but only if this 
    // isn't the last item.
    fileIndex++;
    if (fileIndex > self.postBodyFiles.count) 
    {
      [postData appendUTF8String:startItemBoundary];
    }        
  }
  
  // Append the end boundary
  [postData appendUTF8StringWithFormat:@"\r\n--%@--\r\n", SGHTTPRequestMultipartBoundaryString];
  
  return postData;
}

- (NSData *)JSONPostBodyData
{
  if (self.postBodyParameters.count == 0) 
  {
    return nil;
  }
  
  return [NSJSONSerialization dataWithJSONObject:self.postBodyParameters options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSData *)URLEncodedPostBodyData
{
  if (self.postBodyParameters.count == 0) 
  {
    return nil;
  }
  
  return [[self.postBodyParameters URLEncodedStringValue] dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)finishExecuting
{
  [self willChangeValueForKey:@"isExecuting"];
  [self willChangeValueForKey:@"isFinished"];
  
  self.isExecuting = NO;
  self.isFinished = YES;
  
  [self didChangeValueForKey:@"isExecuting"];
  [self didChangeValueForKey:@"isFinished"];
}

- (void)requestFinishedWithGreatSuccess
{
  [self handleResponseData];
  
  self.loadingStatus = SGHTTPRequestStatusComplete;
  if (self.requestDidFinishBlock) 
  {
    self.requestDidFinishBlock();
  }
  
  [self finishExecuting];
}

- (void)requestFailedWithError:(NSError *)theError
{
  self.loadingStatus = SGHTTPRequestStatusFailed;
  self.error = theError;
  
  if (self.requestDidFailBlock) 
  {
    self.requestDidFailBlock();
  }

  [self finishExecuting];
}

@end