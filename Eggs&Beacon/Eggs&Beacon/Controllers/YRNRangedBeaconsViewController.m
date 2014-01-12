//
//  YRNRangedBeaconsViewController.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 29/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNRangedBeaconsViewController.h"
#import "YRNBeaconManager.h"
#import "YRNEventDetailViewController.h"
#import "YRNBeaconCell.h"
#import "CLBeacon+YRNBeaconManager.h"
#import "UIColor+YRNBeacon.h"

typedef NS_ENUM(NSUInteger, YRNEventType)
{
    YRNEventTypeNone = 0,
    YRNEventTypeWelcome,
    YRNEventTypeMeetAlessio,
    YRNEventTypeAppsterdam,
    YRNEventTypeGoodBye,
};

@interface YRNRangedBeaconsViewController () <YRNBeaconManagerDelegate>

@property (nonatomic, strong) YRNBeaconManager *beaconManager;
@property (nonatomic, strong) NSArray *beacons;
@property (nonatomic, strong) UILocalNotification *currentNotification;

@end

@implementation YRNRangedBeaconsViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeTableView];
    [self registerBeaconRegions];
}

#pragma mark - Beacon manager

- (YRNBeaconManager *)beaconManager
{
    if (!_beaconManager) {
        _beaconManager = [[YRNBeaconManager alloc] init];
        [_beaconManager setDelegate:self];
    }
    return _beaconManager;
}

- (void)registerBeaconRegions
{
    NSString *configurationFilePath = [[NSBundle mainBundle] pathForResource:@"BeaconRegions"
                                                                      ofType:@"plist"];
    NSError *error;
    [[self beaconManager] registerBeaconRegions:[CLBeaconRegion beaconRegionsWithContentsOfFile:configurationFilePath] error:&error];
    if (error)
    {
        NSLog(@"Error registering Beacon regions %@", error);
    }
}

#pragma mark - Table view data source

- (void)customizeTableView
{
    UIView *backgroundView = [[UIView alloc] init];
    [backgroundView setBackgroundColor:[[self class] backgroundColor]];
    [[self tableView] setBackgroundView:backgroundView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self beacons] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BeaconCell";
    YRNBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                          forIndexPath:indexPath];
    CLBeacon *beacon = [self beacons][indexPath.row];
    [[cell UUIDLabel] setText:[[beacon proximityUUID] UUIDString]];
    [[cell majorLabel] setText:[[beacon major] description]];
    [[cell minorLabel] setText:[[beacon minor] description]];
    [[cell proximityView] setProximity:[beacon proximity]];
    [[cell proximityView] setBeaconColor:[UIColor colorForBeacon:beacon]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *backgroundColor = indexPath.row % 2 != 0 ? [UIColor whiteColor] : [UIColor clearColor];
    [cell setBackgroundColor:backgroundColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EventDetail"]) {
        UINavigationController *navigationController = segue.destinationViewController;
		YRNEventDetailViewController *eventViewController = [[navigationController viewControllers] firstObject];
        NSDictionary *notificationInfo = [[self currentNotification] userInfo];
        
        if(notificationInfo)
        {
            YRNEventType eventType = [notificationInfo[@"EventType"] integerValue];
            switch (eventType)
            {
                case YRNEventTypeWelcome:
                    [eventViewController setImageName:@"veespo_logo.jpg"];
                    [eventViewController setEventName:@"Benvenuto!"];
                    [eventViewController setEventText:@"Stiamo creando uno strumento per dar voce a tutti che faciliti l’espressione e la comunicazione delle proprie idee e opinioni. Siamo lieti di ospitarvi qui per questo Talk lab."];
                    break;
                
                case YRNEventTypeGoodBye:
                    [eventViewController setImageName:@"veespo_logo"];
                    [eventViewController setEventName:@"Bye bye"];
                    [eventViewController setEventText:@"Devo ancora trovare un'immagine adatta :P"];
                    break;
                   
                case YRNEventTypeMeetAlessio:
                    [eventViewController setImageName:@"pelo.jpg"];
                    [eventViewController setEventName:@"Conosci New York?"];
                    [eventViewController setEventText:@"Ciao!! Sono Alessio Roberto. Chiedimi informazioni su Veespo, te ne parlerò per ore... Ah, lo sapevi che sono stato recentemente a New York?"];
                    break;
                    
                case YRNEventTypeAppsterdam:
                    [eventViewController setImageName:@"appsterdam"];
                    [eventViewController setEventName:@"Appsterdam Milan"];
                    [eventViewController setEventText:@"Appsterdam è un'associazione nata da un'idea di Mike Lee, sviluppatore iOS di fama mondiale, che ha deciso di creare in Olanda una rete di professionisti nell'ambito del mondo delle applicazioni - siano esse mobile, web, embedded o desktop. Il gruppo promuove la cultura digitale in maniera completa: tra di noi ci sono soprattutto sviluppatori e designer, ma la nostra comunità include anche esperti di comunicazione, di marketing, di economia o legge; ogni singola idea è valida e può trovare ospitalità in Appsterdam."];
                    break;
                
                default:
                    break;
            }
        }
    }
}

- (void)eventInfoForNotification:(UILocalNotification *)notification
{
    [self setCurrentNotification:notification];
    if(![self presentedViewController])
        [self performSegueWithIdentifier:@"EventDetail" sender:self];
}

#pragma mark - YRNBeaconManagerDelegate methods

- (void)beaconManager:(YRNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region
{
    // estimote region
    if([[[region proximityUUID] UUIDString] isEqualToString:YRNEstimoteUUIDString])
    {
        [self createNotification:YRNEventTypeWelcome
                       forRegion:region];
    }
}

- (void)beaconManager:(YRNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region
{
    // estimote region
    if([[[region proximityUUID] UUIDString] isEqualToString:YRNEstimoteUUIDString])
    {
        [self createNotification:YRNEventTypeGoodBye
                       forRegion:region];
    }
}

- (void)beaconManager:(YRNBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region
{
    [self setBeacons:[beacons copy]];
    [[self tableView] reloadData];
    
    // here local notification for Immediate beacons
    for(CLBeacon *beacon in beacons)
    {
        if([beacon proximity] == CLProximityImmediate)
        {
            [self createNotificationForBeacon:beacon];
        }
    }
}

- (IBAction)closeEventModal:(UIStoryboardSegue *)segue
{}

#pragma mark - Local notifications creation

- (void)createNotification:(YRNEventType)notificationType forRegion:(CLBeaconRegion *)region
{
    NSDictionary *notificationInfo = @{@"EventType": [NSNumber numberWithInt:notificationType],
                                       @"UUID": [[region proximityUUID] UUIDString]};
    
    [self createNotification:notificationType withUserInfo:notificationInfo];
}

- (void)createNotificationForBeacon:(CLBeacon *)beacon
{
    YRNEventType rangingEventType = YRNEventTypeNone;
    
    if ([beacon isBlueBeacon])
    {
        NSLog(@"Blue beacon is Immediate!");
        rangingEventType = YRNEventTypeMeetAlessio;
    }
    else if ([beacon isCyanBeacon])
    {
        NSLog(@"Cyan beacon is Immediate!");
        rangingEventType = YRNEventTypeNone;
    }
    else if ([beacon isGreenBeacon])
    {
        NSLog(@"Green beacon is Immediate!");
        rangingEventType = YRNEventTypeAppsterdam;
    }
    NSDictionary *notificationInfo = @{@"EventType": [NSNumber numberWithInt:rangingEventType],
                                       @"UUID": [[beacon proximityUUID] UUIDString],
                                       @"major": [beacon major],
                                       @"minor": [beacon minor]};
    
    [self createNotification:rangingEventType withUserInfo:notificationInfo];
}

- (void)createNotification:(YRNEventType)notificationType withUserInfo:(NSDictionary *)notificationInfo
{
    if(notificationType == YRNEventTypeNone)
        return;
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setUserInfo:notificationInfo];
    
    NSString *notificationText;
    switch (notificationType)
    {
        case YRNEventTypeWelcome:
            notificationText = @"Benvenuto a Veespo!";
            break;
            
        case YRNEventTypeGoodBye:
            notificationText = @"Ciao ciao!";
            break;
            
        case YRNEventTypeMeetAlessio:
            notificationText = @"Ciao Alessio!";
            break;
            
        case YRNEventTypeAppsterdam:
            notificationText = @"Vuoi conoscere Appsterdam?";
            break;
            
        default:
            notificationText = @"";
            break;
    }
    [localNotification setAlertBody:notificationText];
    
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        // app is active, open modal, no notifications
        [self eventInfoForNotification:localNotification];
    }
    else
    {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

#pragma mark - Colors

+ (UIColor *)backgroundColor
{
    return [[UIColor yellowColor] colorWithAlphaComponent:0.1f];
}

@end
