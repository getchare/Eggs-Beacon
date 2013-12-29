//
//  YRNBeaconManager.m
//  Eggs&Beacon
//
//  Created by Marco on 08/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNBeaconManager.h"

@interface YRNBeaconManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign, getter = isInsideBeaconRegion) BOOL insideBeaconRegion;

@end

@implementation YRNBeaconManager

#pragma mark - Initialization

- (void)initLocationServices
{
    if(![self locationManager])
    {
        if(![CLLocationManager locationServicesEnabled])
        {
            //You need to enable Location Services
        }
        else if(![CLLocationManager isRangingAvailable])
        {
            // the device doesn't support ranging of Bluetooth beacons
        }
        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        {
            //You need to authorize Location Services for the APP
        }
        else
        {
            [self setLocationManager:[[CLLocationManager alloc] init]];
            [[self locationManager] setDelegate:self];
        }
    }
}

#pragma mark - Registering beacon regions

- (void)registerBeaconRegion:(CLBeaconRegion *)region
{
    [self initLocationServices];
    
    NSInteger monitoredRegionsCount = [[[self locationManager] monitoredRegions] count];
    if(monitoredRegionsCount >= 20)
    {
        // maximum number of monitored regions reached
    }
    else
    {
        // start monitoring new region
        [[self locationManager] startMonitoringForRegion:region];
        [[self locationManager] requestStateForRegion:region];
    }
}

- (void)unregisterBeaconRegion:(CLBeaconRegion *)region
{
    // stop ranging (?)
    [[self locationManager] stopRangingBeaconsInRegion:region];
    
    // stop monitoring
    [[self locationManager] stopMonitoringForRegion:region];
}

- (void)registerBeaconRegions:(NSArray *)beaconRegions
{
    for (CLBeaconRegion *region in beaconRegions)
    {
        if ([region isKindOfClass:[CLBeaconRegion class]]) {
            [self registerBeaconRegion:region];
        }
    }
}

- (void)unregisterBeaconRegions:(NSArray *)beaconRegions
{    
    for (CLBeaconRegion *region in beaconRegions)
    {
        if ([region isKindOfClass:[CLBeaconRegion class]]) {
            [self unregisterBeaconRegion:region];
        }
    }
}


#pragma mark - CoreLocation delegate methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if([region isKindOfClass:[CLBeaconRegion class]])
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        switch(state)
        {
            case CLRegionStateInside:
                if(![self isInsideBeaconRegion])
                {
                    if([[self delegate] respondsToSelector:@selector(beaconManager:didEnterRegion:)])
                    {
                        [[self delegate] beaconManager:self
                                        didEnterRegion:beaconRegion];
                    }
                    
                    [self setInsideBeaconRegion:YES];
                    [[self locationManager] startRangingBeaconsInRegion:beaconRegion];
                }
                break;
            
            case CLRegionStateOutside:
                if([self isInsideBeaconRegion])
                {
                    if([[self delegate] respondsToSelector:@selector(beaconManager:didExitRegion:)])
                    {
                        [[self delegate] beaconManager:self
                                         didExitRegion:beaconRegion];
                    }
                    
                    [self setInsideBeaconRegion:NO];
                    [[self locationManager] stopRangingBeaconsInRegion:beaconRegion];
                }
                break;
                
            case CLRegionStateUnknown:
                break;
                
            default:
                break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if([beacons count] > 0)
    {
        if([[self delegate] respondsToSelector:@selector(beaconManager:didRangeBeacons:inRegion:)])
        {
            [[self delegate] beaconManager:self
                           didRangeBeacons:beacons
                                  inRegion:region];
        }
    }
}

@end
