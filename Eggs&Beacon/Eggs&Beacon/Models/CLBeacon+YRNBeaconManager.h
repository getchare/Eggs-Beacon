//
//  CLBeacon+YRNBeaconManager.h
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

extern NSString * const YRNEstimoteUUIDString;

/**
 *  Compares hard coded available Estimote beacons.
 */
@interface CLBeacon (YRNBeaconManager)

- (BOOL)isCyanBeacon;

- (BOOL)isBlueBeacon;

- (BOOL)isGreenBeacon;

@end
