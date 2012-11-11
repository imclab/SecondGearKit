//
//  SGPromptedAlertView.h
//  Elements
//
//  Created by Justin Williams on 7/2/10.
//  Copyright 2010 Second Gear. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SGPromptedAlertView : UIAlertView <UITextFieldDelegate>
{
}

@property (nonatomic, strong) UITextField *textField;
@property (weak, readonly) NSString *enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
