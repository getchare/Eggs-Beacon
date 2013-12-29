//
//  CLBeaconRegion+YRNBeaconManager.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 29/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "CLBeaconRegion+YRNBeaconManager.h"

@implementation CLBeaconRegion (YRNBeaconManager)

+ (instancetype)beaconRegionFromDictionary:(NSDictionary *)regionDictionary
{
    NSParameterAssert(regionDictionary);
    CLBeaconRegion *beaconRegion;
    
    NSString *UUIDString = regionDictionary[@"proximityUUID"];
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
    NSAssert(proximityUUID, @"The proximityUUID string is not valid");
    
    NSString *identifier = regionDictionary[@"identifier"];
    NSAssert(identifier, @"The identifier value cannot be nil");
    
    NSNumber *majorNumber = regionDictionary[@"major"];
    CLBeaconMajorValue major = [majorNumber unsignedIntegerValue];
    
    NSNumber *minorNumber = regionDictionary[@"minor"];
    CLBeaconMajorValue minor = [minorNumber unsignedIntegerValue];
    
    if(majorNumber)
    {
        if(minorNumber)
        {
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                   major:major
                                                                   minor:minor
                                                              identifier:identifier];
        }
        else
        {
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                   major:major
                                                              identifier:identifier];
        }
    }
    else
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                          identifier:identifier];
    }
    
    id plistNotifiyOnDisplay = regionDictionary[@"notifyEntryStateOnDisplay"];
    BOOL notifiyOnDisplay = plistNotifiyOnDisplay ? [plistNotifiyOnDisplay boolValue] : NO;
    [beaconRegion setNotifyEntryStateOnDisplay:notifiyOnDisplay];

    id plistNotifiyOnEntry = regionDictionary[@"notifyOnEntry"];
    BOOL notifiyOnEntry = plistNotifiyOnEntry ? [plistNotifiyOnEntry boolValue] : YES;
    [beaconRegion setNotifyOnEntry:notifiyOnEntry];

    id plistNotifiyOnExit = regionDictionary[@"notifyOnExit"];
    BOOL notifiyOnExit = plistNotifiyOnExit ? [plistNotifiyOnExit boolValue] : YES;
    [beaconRegion setNotifyOnExit:notifiyOnExit];
    
    return beaconRegion;
}

+ (NSArray *)beaconRegionsWithContentsOfFile:(NSString *)filePath
{
    NSParameterAssert(filePath);
    NSMutableArray *beaconRegionsArray = [NSMutableArray array];
    
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:filePath];
    if (plistArray) {
        for (NSDictionary *regionDictionary in plistArray) {
            [beaconRegionsArray addObject:[CLBeaconRegion beaconRegionFromDictionary:regionDictionary]];
        }
    }
    return [NSArray arrayWithArray:beaconRegionsArray];
}

@end
