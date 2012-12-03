//
//  SGTwitterController.h
//  Elements
//
//  Created by Justin Williams on 10/19/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGTwitterController : NSObject

- (void)promptForTwitterAccountAccessCompletionHandler:(void(^)())handler;

@end
