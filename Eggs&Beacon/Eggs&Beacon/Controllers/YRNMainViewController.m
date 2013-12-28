//
//  YRNMainViewController.m
//  Eggs&Beacon
//
//  Created by Marco on 27/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNMainViewController.h"

#import "YRNBeaconManager.h"

@interface YRNMainViewController () <YRNBeaconManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;

@property (nonatomic, strong) YRNBeaconManager *beaconManager;

@end


@implementation YRNMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setBeaconManager:[[YRNBeaconManager alloc] initWithConfiguration:@"BeaconRegions"]];
        [[self beaconManager] setDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self beaconManager] registerBeaconRegionsFromConfigurationFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YRNBeaconManagerDelegate methods

- (void)beaconManager:(YRNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region
{
    [[self regionLabel] setText:[region identifier]];
    [[self statusLabel] setText:@"Entered a region"];
}

- (void)beaconManager:(YRNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region
{
    [[self regionLabel] setText:@""];
    [[self beaconLabel] setText:@""];
    [[self distanceLabel] setText:@""];
    [[self majorLabel] setText:@""];
    [[self minorLabel] setText:@""];
    [[self statusLabel] setText:@"Exited a region"];
}

- (void)beaconManager:(YRNBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSArray *proximityArray = @[@"Unknown", @"Immediate", @"Near", @"Far"];
    CLBeacon *nearestBeacon = [beacons firstObject];
    
    [[self regionLabel] setText:[region identifier]];
    [[self beaconLabel] setText:[[nearestBeacon proximityUUID] UUIDString]];
    [[self majorLabel] setText:[[nearestBeacon major] stringValue]];
    [[self minorLabel] setText:[[nearestBeacon minor] stringValue]];
    [[self distanceLabel] setText:[proximityArray objectAtIndex:[nearestBeacon proximity]]];
    [[self statusLabel] setText:@"Ranged a beacon"];
}

@end
