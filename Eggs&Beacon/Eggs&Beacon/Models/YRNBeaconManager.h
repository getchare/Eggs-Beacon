//
//  YRNBeaconManager.h
//  Eggs&Beacon
//
//  Created by Marco on 08/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@class YRNBeaconManager;

@protocol YRNBeaconManagerDelegate <NSObject>

@optional
- (void)beaconManager:(YRNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region;
- (void)beaconManager:(YRNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region;

@end


@interface YRNBeaconManager : NSObject

@property (nonatomic, weak) id<YRNBeaconManagerDelegate> delegate;

@end
