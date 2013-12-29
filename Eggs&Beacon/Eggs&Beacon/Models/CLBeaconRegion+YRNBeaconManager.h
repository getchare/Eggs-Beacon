//
//  CLBeaconRegion+YRNBeaconManager.h
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 29/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLBeaconRegion (YRNBeaconManager)

/**
 *  Initializes a `CLBeaconRegion` object with a dictionary.
 *
 *  @param regionDictionary A dictionary holding the values for the following keys:
 *    "proximityUUID", "identifier", "major", "minor", "notifyEntryStateOnDisplay", "notifyOnEntry", "notifyOnExit".
 *
 *  @return An initialized `CLBeaconRegion` object or nil.
 */
+ (instancetype)beaconRegionFromDictionary:(NSDictionary *)regionDictionary;

/**
 *  Initializes an array of `CLBeaconRegion` objects from dictionaries in a plist file.
 *
 *  @param filePath A file path.
 *
 *  @return An array of `CLBeaconRegion` objects.
 */
+ (NSArray *)beaconRegionsWithContentsOfFile:(NSString *)filePath;

@end
