//
//  YRNRangedBeaconsViewController.m
//  Eggs&Beacon
//
//  Created by Mouhcine El Amine on 29/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNRangedBeaconsViewController.h"
#import "YRNBeaconManager.h"
#import "YRNBeaconDetailViewController.h"
#import "YRNEventDetailViewController.h"

// Blue beacon
static NSUInteger const YRNBlueBeaconMajor = 56595;
static NSUInteger const YRNBlueBeaconMinor = 24731;

// Cyan beacon
static NSUInteger const YRNCyanBeaconMajor = 5848;
static NSUInteger const YRNCyanBeaconMinor = 57228;

// Green beacon
static NSUInteger const YRNGreenBeaconMajor = 9921;
static NSUInteger const YRNGreenBeaconMinor = 23748;

@interface YRNRangedBeaconsViewController () <YRNBeaconManagerDelegate>

typedef enum {
    None = 0,
    Welcome,
	MeetAlessio,
    Appsterdam,
	GoodBye
} EventType;

@property (nonatomic, strong) YRNBeaconManager *beaconManager;
@property (nonatomic, strong) NSArray *beacons;
@property (nonatomic, strong) UILocalNotification *currentNotification;

@end

@implementation YRNRangedBeaconsViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *configurationFilePath = [[NSBundle mainBundle] pathForResource:@"BeaconRegions"
                                                                      ofType:@"plist"];
    NSError *error;
    [[self beaconManager] registerBeaconRegions:[CLBeaconRegion beaconRegionsWithContentsOfFile:configurationFilePath] error:&error];
    if (error)
    {
        NSLog(@"Error registering Beacon regions %@", error);
    }
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self beacons] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BeaconCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    CLBeacon *beacon = [self beacons][indexPath.row];
    cell.textLabel.text = [beacon description];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BeaconDetail"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = sender;
            NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
            CLBeacon *beacon = [self beacons][[indexPath row]];
            YRNBeaconDetailViewController *beaconDetailViewController = [segue destinationViewController];
            [beaconDetailViewController setBeacon:beacon];
        }
    }
    else if ([[segue identifier] isEqualToString:@"EventDetail"]) {
        UINavigationController *navigationController = segue.destinationViewController;
		YRNEventDetailViewController *eventViewController = [[navigationController viewControllers] firstObject];
        NSDictionary *notificationInfo = [[self currentNotification] userInfo];
        
        if(notificationInfo)
        {
            EventType eventType = [(NSNumber *)[notificationInfo objectForKey:@"EventType"] intValue];
            switch (eventType)
            {
                case Welcome:
                    [eventViewController setImageName:@"veespo_logo.jpg"];
                    [eventViewController setEventName:@"Benvenuto in Veespo"];
                    [eventViewController setEventText:@"Stiamo creando uno strumento per dar voce a tutti che faciliti l’espressione e la comunicazione delle proprie idee e opinioni. Queste devono arrivare con forza a chi crea, organizza e amministra. Immaginiamo un network di opinioni condivise a cui piccole e grandi organizzazioni, pubbliche e private, possano accedere per migliorare efficacemente quello che ci circonda."];
                    break;
                
                case GoodBye:
                    [eventViewController setImageName:@"veespo_logo.jpg"];
                    [eventViewController setEventName:@"Bye bye"];
                    [eventViewController setEventText:@"Devo ancora trovare un'immagine adatta :P"];
                    break;
                   
                case MeetAlessio:
                    [eventViewController setImageName:@"pelo.jpg"];
                    [eventViewController setEventName:@"Conosci New York?"];
                    [eventViewController setEventText:@"Ciao!! Sono Alessio Roberto. Chiedimi informazioni su Veespo, te ne parlerò per ore... Ah, lo sapevi che sono stato recentemente a New York?"];
                    break;
                    
                case Appsterdam:
                    [eventViewController setImageName:@"appsterdam"];
                    [eventViewController setEventName:@"Appsterdam Milan"];
                    [eventViewController setEventText:@"Appsterdam è un'associazione nata da un'idea di Mike Lee, sviluppatore iOS di fama mondiale, che ha deciso di creare in Olanda una rete di professionisti nell'ambito del mondo delle applicazioni - siano esse mobile, web, embedded o desktop. Il gruppo promuove la cultura digitale in maniera completa: tra di noi ci sono soprattutto sviluppatori e designer, ma la nostra comunità include anche esperti di comunicazione, di marketing, di economia o legge; ogni singola idea è valida e può trovare ospitalità in Appsterdam."];
                    break;
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
    if([[[region proximityUUID] UUIDString] isEqualToString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"])
    {
        [self createNotification:Welcome
                       forRegion:region];
    }
}

- (void)beaconManager:(YRNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region
{
    // estimote region
    if([[[region proximityUUID] UUIDString] isEqualToString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"])
    {
        [self createNotification:GoodBye
                       forRegion:region];
    }
}

- (void)beaconManager:(YRNBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region
{
    [self setTitle:[region identifier]];
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

- (void)createNotification:(EventType)notificationType forRegion:(CLBeaconRegion *)region
{
    NSDictionary *notificationInfo = @{@"EventType": [NSNumber numberWithInt:notificationType],
                                       @"UUID": [[region proximityUUID] UUIDString]};
    
    [self createNotification:notificationType withUserInfo:notificationInfo];
}

- (void)createNotificationForBeacon:(CLBeacon *)beacon
{
    EventType rangingEventType = None;
    
    switch ([[beacon major] intValue])
    {
        case YRNBlueBeaconMajor:
            if([[beacon minor] intValue] == YRNBlueBeaconMinor)
            {
                NSLog(@"Blue beacon is Immediate!");
                rangingEventType = MeetAlessio;
            }
            break;
            
        case YRNCyanBeaconMajor:
            if([[beacon minor] intValue] == YRNCyanBeaconMinor)
            {
                NSLog(@"Cyan beacon is Immediate!");
                rangingEventType = None;
            }
            break;
            
        case YRNGreenBeaconMajor:
            if([[beacon minor] intValue] == YRNGreenBeaconMinor)
            {
                NSLog(@"Green beacon is Immediate!");
                rangingEventType = Appsterdam;
            }
            break;
            
        default:
            break;
    }
    
    NSDictionary *notificationInfo = @{@"EventType": [NSNumber numberWithInt:rangingEventType],
                                       @"UUID": [[beacon proximityUUID] UUIDString],
                                       @"major": [beacon major],
                                       @"minor": [beacon minor]};
    
    [self createNotification:rangingEventType withUserInfo:notificationInfo];
}

- (void)createNotification:(EventType)notificationType withUserInfo:(NSDictionary *)notificationInfo
{
    if(notificationType == None)
        return;
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setUserInfo:notificationInfo];
    
    NSString *notificationText;
    switch (notificationType)
    {
        case Welcome:
            notificationText = @"Benvenuto a Veespo!";
            break;
            
        case MeetAlessio:
            notificationText = @"Ciao Alessio!";
            
        case GoodBye:
            notificationText = @"Ciao ciao!";
            
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


@end
