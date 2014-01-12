//
//  CLBeacon+YRNBeaconManager.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import "CLBeacon+YRNBeaconManager.h"

NSString * const YRNEstimoteUUIDString = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";

// Blue beacon
static NSUInteger const YRNBlueBeaconMajor = 56595;
static NSUInteger const YRNBlueBeaconMinor = 24731;

// Cyan beacon
static NSUInteger const YRNCyanBeaconMajor = 5848;
static NSUInteger const YRNCyanBeaconMinor = 57228;

// Green beacon
static NSUInteger const YRNGreenBeaconMajor = 9921;
static NSUInteger const YRNGreenBeaconMinor = 23748;

@implementation CLBeacon (YRNBeaconManager)

- (BOOL)isBlueBeacon
{
    return [[[self proximityUUID] UUIDString] isEqualToString:YRNEstimoteUUIDString] &&
    [[self major] integerValue] == YRNBlueBeaconMajor &&
    [[self minor] integerValue] == YRNBlueBeaconMinor;
}

- (BOOL)isCyanBeacon
{
    return [[[self proximityUUID] UUIDString] isEqualToString:YRNEstimoteUUIDString] &&
    [[self major] integerValue] == YRNCyanBeaconMajor &&
    [[self minor] integerValue] == YRNCyanBeaconMinor;
}

- (BOOL)isGreenBeacon
{
    return [[[self proximityUUID] UUIDString] isEqualToString:YRNEstimoteUUIDString] &&
    [[self major] integerValue] == YRNGreenBeaconMajor &&
    [[self minor] integerValue] == YRNGreenBeaconMinor;
}

@end
