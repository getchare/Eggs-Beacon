//
//  YRNBeaconDetailViewController.m
//  Eggs&Beacon
//
//  Created by Marco on 27/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNBeaconDetailViewController.h"

@interface YRNBeaconDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;

@end

@implementation YRNBeaconDetailViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *proximityArray = @[@"Unknown", @"Immediate", @"Near", @"Far"];
    
    [[self beaconLabel] setText:[[[self beacon] proximityUUID] UUIDString]];
    [[self majorLabel] setText:[[[self beacon] major] stringValue]];
    [[self minorLabel] setText:[[[self beacon] minor] stringValue]];
    [[self distanceLabel] setText:[proximityArray objectAtIndex:[[self beacon] proximity]]];
    [[self statusLabel] setText:@"Ranged a beacon"];
}

@end
