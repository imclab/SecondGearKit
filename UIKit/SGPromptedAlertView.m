//
//  SGPromptedAlertView.m
//  Elements
//
//  Created by Justin Williams on 7/2/10.
//  Copyright 2010 Second Gear. All rights reserved.
//

#import "SGPromptedAlertView.h"

enum kPromptAlertViewButtons
{
    kCancelButton = 0,
    kOKButton,
    NUM_BUTTONS
};

@implementation SGPromptedAlertView

@synthesize textField;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)theTitle message:(NSString *)theMessage delegate:(id)theDelegate cancelButtonTitle:(NSString *)theCancelButtonTitle okButtonTitle:(NSString *)theOKButtonTitle
{
    if ((self = [super initWithTitle:theTitle message:theMessage delegate:theDelegate cancelButtonTitle:theCancelButtonTitle otherButtonTitles:theOKButtonTitle, nil]))
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        theTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        theTextField.backgroundColor = [UIColor whiteColor];
        theTextField.delegate = self;
        [self addSubview:theTextField];
        self.textField = theTextField;
        
        // Move the alert up a few pixels higher on the iPad so it feels slightly more natural
        if ((DeviceIsPad()))
        {
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0);
            [self setTransform:translate];
        }
    }
    
    return self;
}


- (void)show
{
    [self.textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText
{
    return textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    [self dismissWithClickedButtonIndex:kOKButton animated:YES];
    [self.delegate alertView:self clickedButtonAtIndex:kOKButton];
    
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect textFieldFrame = self.textField.frame; // CGRectMake(12.0, 45.0, 260.0, 25.0)
    
    if (!DeviceIsPad())
    {
        // On first appearance, the device orientation is set to unknown.  wtf?
        if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown))
        {
            textFieldFrame.origin.y = 45.0f;
        }
        else if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
        {
            textFieldFrame.origin.y = 30.0f;
        }
    }
    
    self.textField.frame = textFieldFrame;
}

@end
