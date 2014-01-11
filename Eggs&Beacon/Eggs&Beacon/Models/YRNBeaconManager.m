//
//  YRNBeaconManager.m
//  Eggs&Beacon
//
//  Created by Marco on 08/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNBeaconManager.h"

static NSUInteger const YRNMaxMonitoredRegions = 20;

@interface YRNBeaconManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign, getter = isInsideBeaconRegion) BOOL insideBeaconRegion;

@end

@implementation YRNBeaconManager

#pragma mark - Initialization

- (void)initLocationServicesError:(NSError * __autoreleasing *)error
{
    if(![self locationManager])
    {
        NSDictionary *userInfo;
        NSInteger errorCode;
        if(![CLLocationManager locationServicesEnabled])
        {
            //You need to enable Location Services
            userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Location services are disabled", nil),
                         NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Turn on the Location Services switch in General settings", nil)};
            errorCode = kCLErrorDenied;
        }
        else if(![CLLocationManager isRangingAvailable])
        {
            // the device doesn't support ranging of Bluetooth beacons
            userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"The device doesn't support ranging of Bluetooth beacons.", nil)};
            errorCode = kCLErrorRangingUnavailable;
        }
        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            //You need to authorize Location Services for the APP
            userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Location services are disabled", nil),
                         NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Turn on the Location Services for the app", nil)};
            errorCode = kCLErrorDenied;
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        {
            userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"The app is not authorized to use Location Services", nil)};
            errorCode = kCLErrorDenied;
        }
        
        if (userInfo) {
            *error = [NSError errorWithDomain:kCLErrorDomain
                                         code:errorCode
                                     userInfo:userInfo];
        }
        else
        {
            [self setLocationManager:[[CLLocationManager alloc] init]];
            [[self locationManager] setDelegate:self];
        }
    }
}

#pragma mark - Registering beacon regions

- (BOOL)registerBeaconRegion:(CLBeaconRegion *)region error:(NSError * __autoreleasing *)error
{
    [self initLocationServicesError:error];
    
    if (error) {
        return NO;
    }
    
    if([[[self locationManager] monitoredRegions] count] >= YRNMaxMonitoredRegions)
    {
        // maximum number of monitored regions reached
        *error = [[self class] reachedMaxMonitoredRegionsError];
        return NO;
    }
    
    // start monitoring new region
    [[self locationManager] startMonitoringForRegion:region];
    [[self locationManager] requestStateForRegion:region];
    return YES;
}

- (void)unregisterBeaconRegion:(CLBeaconRegion *)region
{
    // stop ranging (?)
    [[self locationManager] stopRangingBeaconsInRegion:region];
    
    // stop monitoring
    [[self locationManager] stopMonitoringForRegion:region];
}

- (BOOL)registerBeaconRegions:(NSArray *)beaconRegions error:(NSError * __autoreleasing *)error
{
    if ([[[self locationManager] monitoredRegions] count] + [beaconRegions count] >= YRNMaxMonitoredRegions) {
        // maximum number of monitored regions reached
        *error = [[self class] reachedMaxMonitoredRegionsError];
        return NO;
    }
    else
    {
        for (CLBeaconRegion *region in beaconRegions)
        {
            if ([region isKindOfClass:[CLBeaconRegion class]]) {
                [self registerBeaconRegion:region error:error];
                if (error) {
                    break;
                }
            }
        }
        return error == nil;
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

#pragma mark - Errors

+ (NSError *)reachedMaxMonitoredRegionsError
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Could not register region.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The maximum number of monitored regions was reached", nil)};
    return [NSError errorWithDomain:kCLErrorDomain
                               code:kCLErrorRegionMonitoringFailure
                           userInfo:userInfo];
}

@end
