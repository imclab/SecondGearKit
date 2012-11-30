//
//  SGLocationManager.m
//  SecondGearKit
//
//  Created by Justin Williams on 11/29/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "SGLocationManager.h"

// Notification Constants
NSString *SGLocationManagerUpdatedToDesiredAccuracyNotification = @"SGLocationManagerUpdatedToDesiredAccuracyNotification";
NSString *SGLocationManagerUpdatedNotification = @"SGLocationManagerUpdatedNotification";
NSString *SGLocationManagerFailedNotification = @"SGLocationManagerFailedNotification";
NSString *SGLocationManagerEnteredRegionNotification = @"SGLocationManagerEnteredRegionNotification";
NSString *SGLocationManagerExitedRegionNotification = @"SGLocationManagerExitedRegionNotification";

// Notification Key Constants
NSString *SGLocationManagerErrorKey = @"SGLocationManagerError";
NSString *SGLocationManagerCurrentLocationKey = @"SGLocationManagerCurrentLocation";
NSString *SGLocationManagerRegionKey = @"SGLocationManagerRegion";

// Error Constants
NSString *SGLocationManagerErrorDomain = @"SGLocationManagerErrorDomain";
const NSInteger SGLocationManagerTimedOutError = 1000;

// Distance Constants
CLLocationDistance SGLocationManagerHalfBlockDistance = 160.0;
CLLocationDistance SGLocationManagerOneBlockDistance = 321.0;
CLLocationDistance SGLocationManagerTwoBlockDistance = 642.0;
CLLocationDistance SGLocationManagerHalfMileDistance = 804.0;

NSTimeInterval SGLocationManagerUpdateTimeoutIntervalNone = -1.0;

@interface SGLocationManager ()
@property (nonatomic, strong) NSDate *locationUpdateStartDate;
@end

@implementation SGLocationManager

- (id)init
{
    if ((self = [super init]))
    {
        self.delegate = self;
        _locationUpdateTimeoutInterval = SGLocationManagerUpdateTimeoutIntervalNone;
        _requiredAccuracy = SGLocationManagerTwoBlockDistance;
        _throttlesUpdatesAfterRequiredAccuracy = NO;
    }
    
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark -
#pragma mark Region Monitoring
// +--------------------------------------------------------------------
// | Region Monitoring
// +--------------------------------------------------------------------

- (void)stopMonitoringAllRegions
{
    NSSet *regions = self.monitoredRegions;
    
    for (CLRegion *currentRegion in regions)
    {
        [self stopMonitoringForRegion:currentRegion];
    }
}


#pragma mark -
#pragma mark CLLocationManager Methods
// +--------------------------------------------------------------------
// | CLLocationManager Methods
// +--------------------------------------------------------------------

- (void)startUpdatingLocation
{
    if (self.locationUpdateStartDate != nil)
    {
        return;
    }
    
    self.locationUpdateStartDate = [NSDate date];
    [super startUpdatingLocation];
}

- (void)startMonitoringSignificantLocationChanges
{
    self.locationUpdateStartDate = [NSDate date];
    [super startMonitoringSignificantLocationChanges];
}

- (void)stopUpdatingLocation
{
    [super stopUpdatingLocation];
    self.locationUpdateStartDate = nil;
}

- (void)stopMonitoringSignificantLocationChanges
{
    self.locationUpdateStartDate = nil;
    [super stopMonitoringSignificantLocationChanges];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
// +--------------------------------------------------------------------
// | CLLocationManagerDelegate Methods
// +--------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self != manager)
    {
        return;
    }
    
    // If the new location is cached, ignore this location update
    if ([self.locationUpdateStartDate laterDate:newLocation.timestamp] == self.locationUpdateStartDate)
    {
        return;
    }
    
    //NSLog(@"Got location update to: %@ distance from old location: %f", newLocation, [newLocation distanceFromLocation:oldLocation]);
    
    // If the old location was sufficiently accurate and the new location
    // isn't substantially different distance-wise, ignore this update
    if ((self.requiredAccuracy != kCLDistanceFilterNone && self.throttlesUpdatesAfterRequiredAccuracy) && (oldLocation && oldLocation.horizontalAccuracy <= self.requiredAccuracy && [newLocation distanceFromLocation:oldLocation] >= self.distanceFilter))
    {
        return;
    }
    
    // Build up a user info object for the notifications
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    NSNotification *notification = nil;
    if (newLocation)
    {
        userInfo[SGLocationManagerCurrentLocationKey] = newLocation;
    }
    
    if (self.requiredAccuracy != kCLDistanceFilterNone && newLocation.horizontalAccuracy <= self.requiredAccuracy)
    {
        notification = [NSNotification notificationWithName:SGLocationManagerUpdatedToDesiredAccuracyNotification object:self userInfo:userInfo];
    }
    else if (self.locationUpdateTimeoutInterval != SGLocationManagerUpdateTimeoutIntervalNone && abs([newLocation.timestamp timeIntervalSinceDate:self.locationUpdateStartDate]) > self.locationUpdateTimeoutInterval)
    {
        // We timed out before we could get a location with the desired accuracy
        [self stopUpdatingLocation];
        
        NSError *error = [NSError errorWithDomain:SGLocationManagerErrorDomain code:SGLocationManagerTimedOutError userInfo:nil];
        [userInfo setObject:error forKey:SGLocationManagerErrorKey];
        notification = [NSNotification notificationWithName:SGLocationManagerFailedNotification object:self userInfo:userInfo];
    }
    else
    {
        // We got an updated location, but haven't reached
        // the desired accuracy yet. Notify appropriately.
        notification = [NSNotification notificationWithName:SGLocationManagerUpdatedNotification object:self userInfo:userInfo];
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self != manager)
    {
        return;
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:SGLocationManagerErrorKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SGLocationManagerFailedNotification object:self userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:region forKey:SGLocationManagerRegionKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SGLocationManagerEnteredRegionNotification object:self userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:region forKey:SGLocationManagerRegionKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:SGLocationManagerExitedRegionNotification object:self userInfo:userInfo];
}

@end
