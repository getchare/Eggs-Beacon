//
//  UIColor+YRNBeacon.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import "UIColor+YRNBeacon.h"
#import "CLBeacon+YRNBeaconManager.h"

@implementation UIColor (YRNBeacon)

+ (UIColor *)colorForBeacon:(CLBeacon *)beacon
{
    UIColor *color = [UIColor greenColor];
    if ([beacon isBlueBeacon])
    {
        color = [UIColor blueColor];
    }
    else if ([beacon isCyanBeacon])
    {
        color = [UIColor cyanColor];
    }
    return color;
}

@end
