/*
 
 The MIT License
 
 Copyright (c) 2010 Second Gear LLC
 
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

#import "SGAlertView.h"

NSString * const SGAlertTitleKey = @"SGAlertTitleKey";

@implementation SGAlertView

@synthesize alertView;
@synthesize blocks;

+ (SGAlertView *)showAlertWithError:(NSError *)error
{
    NSString *message = [error localizedDescription];
    if ([message rangeOfString:@"Expected status code"].location != NSNotFound)
    {
        message = NSLocalizedString(@"Unable to connect to the server. Please try again.", @"");
    }
    SGAlertView *alertView = [[self alloc] initWithTitle:[error userInfo][SGAlertTitleKey]
                                                 message:[error localizedDescription]
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    return alertView;
}


- (id)initWithTitle:(NSString *)theTitle message:(NSString *)theMessage
{
    if ((self = [super init]))
    {
        alertView = [[UIAlertView alloc] initWithTitle:theTitle
                                               message:theMessage
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
        [alertView setCancelButtonIndex:-1];
        blocks = [[NSMutableArray alloc] init];
    }
    
    return self;
}



#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)addButtonWithTitle:(NSString *)theTitle block:(SGAlertViewCompletionHandlerBlock)theBlock
{
    [blocks addObject:[theBlock copy]];
    [alertView addButtonWithTitle:theTitle];
}

- (void)show
{
    [alertView show];
    
    // Ensure that the we hang around until the sheet is dismissed
}

#pragma mark -
#pragma mark UIAlertView Delegate Methods
// +--------------------------------------------------------------------
// | UIAlertView Delegate Methods
// +--------------------------------------------------------------------

- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)theButtonIndex
{
    if (theButtonIndex == [theAlertView cancelButtonIndex]) return;
    
    if ((theButtonIndex >= 0) && (theButtonIndex <= [blocks count]))
    {
        void (^b)() = blocks[(theButtonIndex)];
        b();
    }
    
}

@end
