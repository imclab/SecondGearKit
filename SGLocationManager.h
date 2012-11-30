//
//  SGLocationManager.h
//  SecondGearKit
//
//  Created by Justin Williams on 11/29/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

extern NSString *SGLocationManagerUpdatedToDesiredAccuracyNotification;
extern NSString *SGLocationManagerUpdatedNotification;
extern NSString *SGLocationManagerFailedNotification;
extern NSString *SGLocationManagerEnteredRegionNotification;
extern NSString *SGLocationManagerExitedRegionNotification;
extern NSString *SGLocationManagerErrorKey;
extern NSString *SGLocationManagerCurrentLocationKey;
extern NSString *SGLocationManagerRegionKey;

extern CLLocationDistance SGLocationManagerHalfBlockDistance;
extern CLLocationDistance SGLocationManagerOneBlockDistance;
extern CLLocationDistance SGLocationManagerTwoBlockDistance;
extern CLLocationDistance SGLocationManagerHalfMileDistance;

@interface SGLocationManager : CLLocationManager <CLLocationManagerDelegate>

@property (nonatomic, assign) NSTimeInterval locationUpdateTimeoutInterval;
@property (nonatomic, assign) CLLocationAccuracy requiredAccuracy;
@property (nonatomic, assign) BOOL throttlesUpdatesAfterRequiredAccuracy;

- (void)stopMonitoringAllRegions;

@end
