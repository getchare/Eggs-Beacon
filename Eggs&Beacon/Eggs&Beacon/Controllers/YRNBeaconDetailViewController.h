//
//  YRNBeaconDetailViewController.h
//  Eggs&Beacon
//
//  Created by Marco on 27/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YRNBeaconDetailViewController : UIViewController

@property (nonatomic, strong) CLBeacon *beacon;

@end
