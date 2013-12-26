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
@property (nonatomic, strong) NSMutableArray *beaconRegions;
@property (nonatomic, strong) NSString *configurationFileName;

@end


@implementation YRNBeaconManager

#pragma mark - Initialization

- (id)initWithConfiguration:(NSString *)fileName
{
    self = [super init];
    
    if(self)
    {
        [self setBeaconRegions:[NSMutableArray array]];
        [self setConfigurationFileName:fileName];
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
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [[self locationManager] setDelegate:self];
    }
}

#pragma mark - Registering beacon regions

- (void)registerBeaconRegion:(CLBeaconRegion *)region
{
    // add region array
    [[self beaconRegions] addObject:region];
    
    [self initLocationServices];
    
    // start monitoring new region
    [[self locationManager] startMonitoringForRegion:region];
}

- (void)registerBeaconRegionsFromFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[self configurationFileName]
                                                     ofType:@"plist"];
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
        BOOL notifiyOnDisplay = [regionDictionary[@"notifyEntryStateOnDisplay"] boolValue];
        BOOL notifiyOnEntry = [regionDictionary[@"notifyOnEntry"] boolValue];
        BOOL notifiyOnExit = [regionDictionary[@"notifyOnExit"] boolValue];
        
        CLBeaconRegion *newRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                            major:major
                                                                            minor:minor
                                                                       identifier:identifier];
        
        [newRegion setNotifyEntryStateOnDisplay:notifiyOnDisplay];
        [newRegion setNotifyOnEntry:notifiyOnEntry];
        [newRegion setNotifyOnExit:notifiyOnExit];
        
        [self registerBeaconRegion:newRegion];
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
                if([self delegate] && [self respondsToSelector:@selector(beaconManager:didEnterRegion:)])
                    [[self delegate] beaconManager:self didEnterRegion:beaconRegion];
                break;
            
            case CLRegionStateOutside:
                if([self delegate] && [self respondsToSelector:@selector(beaconManager:didExitRegion:)])
                    [[self delegate] beaconManager:self didExitRegion:beaconRegion];
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
    
}

@end
