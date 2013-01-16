/*
 
 The MIT License
 
 Copyright (c) 2013 Second Gear LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


#import "UIActionSheet+SGExtensions.h"
#import <objc/runtime.h>

static const NSString *kButtonItemsArrayKey = @"kButtonItemsArrayKey";

@implementation UIActionSheet (SGExtensions)

- (instancetype)initWithTitle:(NSString *)title
{
  if ((self = [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]))
  {
    
  }
  return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButton:(SGButtonItem *)cancelButton destructiveButton:(SGButtonItem *)destructiveButton otherButtons:(NSArray *)otherButtons
{
  if ((self = [self initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]))
  {    
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    [buttonsArray addObjectsFromArray:otherButtons];
    
    for (SGButtonItem *buttonItem in buttonsArray)
    {
      [self addButtonWithTitle:buttonItem.label block:buttonItem.action];
    }
    
    if (destructiveButton != nil)
    {
      [buttonsArray addObject:destructiveButton];
      NSInteger destIndex = [self addButtonWithTitle:destructiveButton.label];
      [self setDestructiveButtonIndex:destIndex];
    }
    
    if (cancelButton != nil)
    {
      [buttonsArray addObject:cancelButton];
      NSInteger cancelIndex = [self addButtonWithTitle:cancelButton.label];
      [self setCancelButtonIndex:cancelIndex];
    }
    
    objc_setAssociatedObject(self, &kButtonItemsArrayKey, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return self;
}

#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)setCancelButtonWithTitle:(NSString *)theTitle block:(UIActionSheetExtensionsBlock)theBlock
{
  SGButtonItem *cancelButton = [SGButtonItem buttonItemWithLabel:theTitle];
  cancelButton.action = theBlock;
  
  [self addButtonItem:cancelButton];
  NSInteger cancelIndex = [self addButtonWithTitle:cancelButton.label];
  [self setCancelButtonIndex:cancelIndex];
}

- (void)addButtonWithTitle:(NSString *)theTitle block:(UIActionSheetExtensionsBlock)theBlock
{
  SGButtonItem *buttonItem = [SGButtonItem buttonItemWithLabel:theTitle];
  buttonItem.action = theBlock;
  [self addButtonItem:buttonItem];
}

- (NSUInteger)addButtonItem:(SGButtonItem *)buttonItem
{
  NSMutableArray *buttonsArray = objc_getAssociatedObject(self, &kButtonItemsArrayKey);
  
  // jww: protecting against someone calling `init` instead of `initWithTitle:` when creating
  // the sheet
  if (buttonsArray == nil)
  {
    buttonsArray = [[NSMutableArray alloc] init];
    objc_setAssociatedObject(self, &kButtonItemsArrayKey, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
	NSInteger buttonIndex = [self addButtonWithTitle:buttonItem.label];
	[buttonsArray addObject:buttonItem];
  
  // jww: Same protection as above.
  if (self.delegate == nil)
  {
    self.delegate = self;
  }
  
	return buttonIndex;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods
// +--------------------------------------------------------------------
// | UIActionSheet Delegate Methods
// +--------------------------------------------------------------------

- (void)actionSheet:(UIActionSheet *)theSheet clickedButtonAtIndex:(NSInteger)theButtonIndex
{
  // Action sheets pass back -1 when they're cleared for some reason other than a button being
  // pressed.
  if (theButtonIndex >= 0)
  {
    NSArray *buttonsArray = objc_getAssociatedObject(self, &kButtonItemsArrayKey);
    SGButtonItem *item = [buttonsArray objectAtIndex:theButtonIndex];
    if (item.action != nil)
    {
      item.action();
    }
  }
  
  objc_setAssociatedObject(self, &kButtonItemsArrayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
