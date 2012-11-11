//
//  SGPopoverManager.h
//  Second Gear Pitbox
//
//  Created by Justin Williams on 3/15/10.
//  Copyright 2010 w. All rights reserved.
//
//  Helper class to make it easy to maintain only a single popover controller visible at a time.

extern NSString *const SGUIPopoverControllerDidDismissNotification;

@interface SGPopoverManager : NSObject <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *currentPopoverController;
@property (nonatomic, assign) BOOL permitCurrentPopoverControllerToDismiss;

+ (SGPopoverManager *)defaultManager;

- (void)presentPopoverController:(UIPopoverController *)pc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)presentPopoverController:(UIPopoverController *)pc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)presentControllerInPopoverController:(UIViewController *)vc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)presentControllerInPopoverController:(UIViewController *)vc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

- (void)dismissCurrentPopoverController:(BOOL)animated;


@end
