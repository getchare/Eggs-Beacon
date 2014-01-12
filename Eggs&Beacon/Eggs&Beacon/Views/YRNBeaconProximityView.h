//
//  YRNBeaconProximityView.h
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface YRNBeaconProximityView : UIView

/**
 *  The color used to draw the iPhone.
 *
 *  @discussion Default is [UIColor greenColor];
 */
@property (nonatomic, strong) UIColor *beaconColor UI_APPEARANCE_SELECTOR;

/**
 *  The color used to draw the iPhone.
 *
 *  @discussion Default is [UIColor whiteColor];
 */
@property (nonatomic, strong) UIColor *iPhoneColor UI_APPEARANCE_SELECTOR;

/**
 *  The radar color.
 *
 *  @discussion Default is [UIColor blackColor];
 */
@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;

/**
 *  The proximity.
 */
@property (nonatomic) CLProximity proximity;

@end
