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

/**
 *  The `YRNBeaconManagerDelegate` protocol defines the methods used to receive beacon ranging and region entering 
 *  or exit updates from a `YRNBeaconManager` object.
 */
@protocol YRNBeaconManagerDelegate <NSObject>

@optional

/**
 *  Tells the delegate that the user entered the specified beacon region.
 *
 *  @param manager The beacon manager object reporting the event.
 *  @param region  The beacon region that was entered.
 */
- (void)beaconManager:(YRNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region;

/**
 *  Tells the delegate that the user left the specified beacon region.
 *
 *  @param manager The beacon manager object reporting the event.
 *  @param region  The beacon region that was left.
 */
- (void)beaconManager:(YRNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region;

/**
 *  Tells the delegate that one or more beacons are in range.
 *
 *  @param manager The beacon manager object reporting the event.
 *  @param beacons An array of CLBeacon objects representing the beacons currently in range.
 *  @param region  The region object containing the parameters that were used to locate the beacons.
 */
- (void)beaconManager:(YRNBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end

/**
 *  The `YRNBeaconManager` class defines the interface for configuring the delivery of iBeacons ranging and
 *  regions entry and exits events to your application. You can use an instance of this class to monitor specific beacon 
 *  regions to monitor.
 */
@interface YRNBeaconManager : NSObject

/**
 *  The delegate.
 */
@property (nonatomic, weak) id<YRNBeaconManagerDelegate> delegate;

/**
 *  Starts monitoring a beacon region.
 *
 *  @param region A CLBeaconRegion object. This parameter must not be nil.
 */
- (void)registerBeaconRegion:(CLBeaconRegion *)region;

/**
 *  Starts monitoring a list of beacon regions.
 *
 *  @param regions An array of CLBeaconRegion objects.
 */
- (void)registerBeaconRegions:(NSArray *)regions;

@end
