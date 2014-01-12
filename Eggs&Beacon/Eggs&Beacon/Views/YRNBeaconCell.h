//
//  YRNBeaconCell.h
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 12/01/14.
//  Copyright (c) 2014 Yron Lab. All rights reserved.
//

#import "YRNBeaconProximityView.h"

@interface YRNBeaconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *UUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet YRNBeaconProximityView *proximityView;

@end
