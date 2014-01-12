//
//  YRNAppDelegate.m
//  Eggs&Beacon
//
//  Created by Marco on 08/12/13.
//  Copyright (c) 2013 Yron Lab. All rights reserved.
//

#import "YRNAppDelegate.h"
#import "YRNRangedBeaconsViewController.h"

@implementation YRNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification)
    {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        
        [self application:application didReceiveLocalNotification:locationNotification];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    YRNRangedBeaconsViewController *rangedViewController = [[(UINavigationController *)[[self window] rootViewController] viewControllers] firstObject];
    
    [rangedViewController eventInfoForNotification:notification];
}

@end
