//
//  SGTwitterController.m
//  Elements
//
//  Created by Justin Williams on 10/19/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "NSArray+SGAdditions.h"
#import "SGTwitterController.h"
#import "SGProgressHUD.h"
#import "SGAlertView.h"

@interface SGTwitterController ()
@property (nonatomic, strong) UIAlertView *followOnTwitterAlertView;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSMutableArray *twitterAccounts;

- (void)followUsingTwitterAccount:(ACAccount *)account;
@end

@implementation SGTwitterController

- (instancetype)init
{
    if ((self = [super init]))
    {
        _twitterAccounts = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)promptToFollowOnTwitter
{
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [self.accountStore accountsWithAccountType:twitterAccountType];
    
    if ([accountsArray count] == 0) // User doesn't have any Twitter accounts setup in Settings.
    {
        [self followUsingExternalTwitterApp];
        return;
    }
    
    NSString *title = NSLocalizedString(@"Follow Second Gear On Twitter", @"");
    self.followOnTwitterAlertView = [[UIAlertView alloc] initWithTitle:title
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                     otherButtonTitles:nil];
    
    [self.twitterAccounts removeAllObjects];
    if ([accountsArray count] == 1)
    {
        [self.twitterAccounts addObject:[accountsArray firstObject]];
        self.followOnTwitterAlertView.message = NSLocalizedString(@"Tap 'Follow' to add @secondgear to your following list.", @"");
        [self.followOnTwitterAlertView addButtonWithTitle:NSLocalizedString(@"Follow", @"")];
    }
    else if ([accountsArray count] > 0) // Let the user select from their list of accounts
    {
        for (ACAccount *account in accountsArray)
        {
            [self.twitterAccounts addObject:account];
            NSString *accountName = [NSString stringWithFormat:@"@%@", account.username];
            [self.followOnTwitterAlertView addButtonWithTitle:accountName];
        }
    }
    
    [self.followOnTwitterAlertView show];
}

- (void)promptForTwitterAccountAccessCompletionHandler:(void(^)())handler
{
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted == YES)
            {
                [self promptToFollowOnTwitter];
            }
            else   // User rejected our access to their accounts.
            {
                [self followUsingExternalTwitterApp];
            }
        });
    }];
    handler(nil);
}

- (void)followUsingExternalTwitterApp
{
    NSArray *twitterURLS = [NSArray arrayWithObjects:[NSURL URLWithString:@"tweetbot:///user_profile/secondgear"],
                            [NSURL URLWithString:@"twitter://user?screen_name=secondgear"],
                            [NSURL URLWithString:@"twitterrific:///profile?screen_name=secondgear"],
                            [NSURL URLWithString:@"echofonpro:///user_timeline?secondgear"],
                            [NSURL URLWithString:@"echofon:///user_timeline?secondgear"],
                            [NSURL URLWithString:@"https://www.twitter.com/secondgear"], nil];
    
    NSURL *url;
    for (NSURL *twitterURL in twitterURLS)
    {
        if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
        {
            url = twitterURL;
            break;
        }
    }
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)followUsingTwitterAccount:(ACAccount *)twitterAccount
{
    static NSString *kTwitterScreenNameKey = @"screen_name";
    static NSString *kTwitterFollowKey = @"follow";
    static NSString *kSecondGearTwitterName = @"secondgear";
    NSMutableDictionary *followRequestParameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    kSecondGearTwitterName, kTwitterScreenNameKey,
                                                    @"true", kTwitterFollowKey, nil];
    
    NSURL *followRequestURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.json"];
    
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:followRequestURL parameters:followRequestParameters];
    
    postRequest.account = twitterAccount;
    
    SGProgressHUD *hud = [SGProgressHUD showHUDAnimated:YES];
    hud.labelText = NSLocalizedString(@"Following", @"");
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SGProgressHUD hideHUDAnimated:YES];
            
            if (error != nil)
            {
                NSLog(@"Twitter returned the following error while trying to follow: %@", error);
                [SGAlertView showAlertWithError:error];
            }
        });
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.followOnTwitterAlertView)
    {
        static const NSInteger kCancelButton = 0;
        switch (buttonIndex)
        {
            case kCancelButton:
            {
                break;
            }
            default:
            {
                ACAccount *account = [self.twitterAccounts objectAtIndex:(buttonIndex - 1)];
                [self followUsingTwitterAccount:account];
                break;
            }
        }
    }
}


@end
