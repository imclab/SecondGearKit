//
//  SGButtonItem.h
//  PTUtilities
//
//  Created by Justin Williams on 1/2/13.
//  Copyright (c) 2013 Smile Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SGButtonItemActionBlock)();

@interface SGButtonItem : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, copy) SGButtonItemActionBlock action;

+ (instancetype)buttonItem;
+ (instancetype)buttonItemWithLabel:(NSString *)label;
+ (instancetype)buttonItemWithLabel:(NSString *)label action:(SGButtonItemActionBlock)action;

@end
