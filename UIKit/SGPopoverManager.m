//
//  SGPopoverManager.m
//  Second Gear Pitbox
//
//  Created by Justin Williams on 3/15/10.
//  Copyright 2010 w. All rights reserved.
//

#import "SGPopoverManager.h"

NSString *const SGUIPopoverControllerDidDismissNotification = @"SGUIPopoverControllerDidDismissNotification";

static SGPopoverManager *sDefaultPopoverManager = nil;

@implementation SGPopoverManager

@synthesize currentPopoverController;
@synthesize permitCurrentPopoverControllerToDismiss;

+ (SGPopoverManager *)defaultManager
{
    @synchronized(self)
    {
        if (sDefaultPopoverManager == nil)
		{
            sDefaultPopoverManager = [[self alloc] init];
            sDefaultPopoverManager.permitCurrentPopoverControllerToDismiss = YES;
		}
	}
    
    return sDefaultPopoverManager;
}

- (void)presentPopoverController:(UIPopoverController *)pc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    self.currentPopoverController = pc;
    [self.currentPopoverController presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
}

- (void)presentPopoverController:(UIPopoverController *)pc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    self.currentPopoverController = pc;
    [self.currentPopoverController presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
}

- (void)dismissCurrentPopoverController:(BOOL)animated;
{
    [self.currentPopoverController dismissPopoverAnimated:animated];
}

- (void)presentControllerInPopoverController:(UIViewController *)vc fromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
{
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:vc];
    [self presentPopoverController:pc fromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
}

- (void)presentControllerInPopoverController:(UIViewController *)vc fromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
{
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:vc];
    [self presentPopoverController:pc fromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SGUIPopoverControllerDidDismissNotification object:popoverController];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return self.permitCurrentPopoverControllerToDismiss;
}

#pragma mark -
#pragma mark Dynamic Accessor Methods
// +--------------------------------------------------------------------
// | Dynamic Accessor Methods
// +--------------------------------------------------------------------

- (void)setCurrentPopoverController:(UIPopoverController *)thePopoverController
{
    @synchronized(@"currentPopoverController")
	{
        [self dismissCurrentPopoverController:YES];
        
        if ((currentPopoverController != thePopoverController))
		{
            currentPopoverController = thePopoverController;
            currentPopoverController.delegate = self;
		}
        
        self.permitCurrentPopoverControllerToDismiss = YES;
	}
}

@end
