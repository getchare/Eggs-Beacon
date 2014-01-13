//
//  YRNBluetoothHUD.h
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 13/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRNBluetoothHUD : UIView

/**
 *  Shows the bluetooth hud.
 */
+ (void)show;

/**
 *  Hides the bluetooth hud.
 */
+ (void)hide;

/**
 *  Checks whether the hud is visible.
 *
 *  @return YES if the hud is visible, NO otherwise.
 */
+ (BOOL)isVisible;

@end
