//
//  YRNBeaconManager.m
//  Eggs&Beacon
//
//  Created by Marco on 08/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNBeaconManager.h"


#define kDefaultConfigurationFileName   @"BeaconsList.plist"


@interface YRNBeaconManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *configurationFileName;
@property (nonatomic, assign, getter = isInsideBeaconRegion) BOOL insideBeaconRegion;

@end


@implementation YRNBeaconManager

#pragma mark - Initialization

- (id)initWithConfiguration:(NSString *)fileName
{
    self = [super init];
    
    if(self)
    {
        [self setConfigurationFileName:fileName];
        [self setInsideBeaconRegion:NO];
    }
    
    return self;
}

- (id)init
{
    return [self initWithConfiguration:kDefaultConfigurationFileName];
}

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
    }
}

- (void)unregisterBeaconRegion:(CLBeaconRegion *)region
{
    // stop ranging (?)
    [[self locationManager] stopRangingBeaconsInRegion:region];
    
    // stop monitoring
    [[self locationManager] stopMonitoringForRegion:region];
}

- (NSArray *)beaconRegionsFromConfigurationFile
{
    NSMutableArray *beaconRegions = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[self configurationFileName]
                                                         ofType:@"plist"];
    if(filePath)
    {
        NSArray *regionArray = [NSArray arrayWithContentsOfFile:filePath];
        
        for (NSDictionary *regionDictionary in regionArray)
        {
            NSString *UUIDString = regionDictionary[@"proximityUUID"];
            NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
            NSString *identifier = regionDictionary[@"identifier"];
            NSNumber *majorNumber = regionDictionary[@"major"];
            CLBeaconMajorValue major = [majorNumber unsignedIntegerValue];
            NSNumber *minorNumber = regionDictionary[@"minor"];
            CLBeaconMajorValue minor = [minorNumber unsignedIntegerValue];
            
            id plistNotifiyOnDisplay = regionDictionary[@"notifyEntryStateOnDisplay"];
            BOOL notifiyOnDisplay = plistNotifiyOnDisplay ? [plistNotifiyOnDisplay boolValue] : NO;
            id plistNotifiyOnEntry = regionDictionary[@"notifyOnEntry"];
            BOOL notifiyOnEntry = plistNotifiyOnEntry ? [plistNotifiyOnEntry boolValue] : YES;
            id plistNotifiyOnExit = regionDictionary[@"notifyOnExit"];
            BOOL notifiyOnExit = plistNotifiyOnExit ? [plistNotifiyOnExit boolValue] : YES;
            
            CLBeaconRegion *newRegion;
            
            if(majorNumber)
            {
                if(minorNumber)
                {
                    newRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                        major:major
                                                                        minor:minor
                                                                   identifier:identifier];
                }
                else
                {
                    newRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                        major:major
                                                                   identifier:identifier];
                }
            }
            else
            {
                newRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                               identifier:identifier];
            }
            
            [newRegion setNotifyEntryStateOnDisplay:notifiyOnDisplay];
            [newRegion setNotifyOnEntry:notifiyOnEntry];
            [newRegion setNotifyOnExit:notifiyOnExit];
            
            [beaconRegions addObject:newRegion];
        }
    }
    else
    {
        // no configuration file
    }
    
    return beaconRegions;
}

- (void)registerBeaconRegionsFromConfigurationFile
{
    NSArray *beaconRegions = [self beaconRegionsFromConfigurationFile];
    
    for (CLBeaconRegion *region in beaconRegions)
    {
        [self registerBeaconRegion:region];
    }
}

- (void)unregisterBeaconRegionsFromConfigurationFile
{
    NSArray *beaconRegions = [self beaconRegionsFromConfigurationFile];
    
    for (CLBeaconRegion *region in beaconRegions)
    {
        [self unregisterBeaconRegion:region];
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
                    if([self delegate] &&
                       [[self delegate] respondsToSelector:@selector(beaconManager:didEnterRegion:)])
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
                    if([self delegate] &&
                       [[self delegate] respondsToSelector:@selector(beaconManager:didExitRegion:)])
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
        if([self delegate] &&
           [[self delegate] respondsToSelector:@selector(beaconManager:didRangeBeacons:inRegion:)])
        {
            [[self delegate] beaconManager:self
                           didRangeBeacons:beacons
                                  inRegion:region];
        }
    }
}

@end
