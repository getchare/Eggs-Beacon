//
//  YRNBeaconManager.h
//  Eggs&Beacon
//
//  Created by Marco on 08/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CLBeaconRegion+YRNBeaconManager.h"

@class YRNBeaconManager;

@protocol YRNBeaconManagerDelegate <NSObject>

@optional
- (void)beaconManager:(YRNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region;
- (void)beaconManager:(YRNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region;
- (void)beaconManager:(YRNBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end

@interface YRNBeaconManager : NSObject

@property (nonatomic, weak) id<YRNBeaconManagerDelegate> delegate;

- (void)registerBeaconRegion:(CLBeaconRegion *)region;
- (void)registerBeaconRegions:(NSArray *)regions;

@end
