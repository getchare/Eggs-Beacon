//
//  UIColor+YRNBeacon.h
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

@class CLBeacon;

@interface UIColor (YRNBeacon)

/**
 *  Returns the real world color of some defined beacons.
 *
 *  @param beacon A CLBeacon object.
 *
 *  @return A UIColor.
 */
+ (UIColor *)colorForBeacon:(CLBeacon *)beacon;

@end
