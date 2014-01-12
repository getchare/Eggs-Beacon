//
//  YRNBeaconCell.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import "YRNBeaconCell.h"

@implementation YRNBeaconCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [[self proximityView] setProximity:CLProximityUnknown];
    [[self UUIDLabel] setText:nil];
    [[self majorLabel] setText:nil];
    [[self minorLabel] setText:nil];
}

@end
