//
//  AnythingDBAppDelegate.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMainWindowController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "CAnythingDBServer.h"
//#import "CBumpManager.h"
#import "CLocationTracker.h"
#import "NSUserDefaults_AnythingBucketExtensions.h"
#import "UIAlertView_BlocksExtensions.h"

@interface CMainWindowController () <UIApplicationDelegate, UITabBarControllerDelegate>
@end

#pragma mark -

@implementation CMainWindowController

@synthesize window;


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
    {
    }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
	UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
	theNotification.alertBody = @"application:didFinishLaunchingWithOptions:";
	theNotification.hasAction = NO;
	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];

	if ([NSUserDefaults standardUserDefaults].username.length == 0 || [NSUserDefaults standardUserDefaults].password == 0)
		{
        UIAlertView *theAlertView = [[UIAlertView alloc] initWithTitle:@"Login" message:NULL handler:^(UIAlertView *inAlertView, NSInteger buttonIndex) {
            [NSUserDefaults standardUserDefaults].username = [inAlertView textFieldAtIndex:0].text;
            [NSUserDefaults standardUserDefaults].password = [inAlertView textFieldAtIndex:1].text;
            [[NSUserDefaults standardUserDefaults] synchronize];
            } cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", NULL];
        theAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [theAlertView show];
        }
    
    
    [self.window makeKeyAndVisible];
    [CAnythingDBServer sharedInstance];
	
	[CLocationTracker sharedInstance];
	
    return(YES);
    }

- (void)applicationWillResignActive:(UIApplication *)application
    {
	UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
	theNotification.alertBody = @"applicationWillResignActive";
	theNotification.hasAction = NO;
	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];
    }

- (void)applicationDidEnterBackground:(UIApplication *)application
    {
	UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
	theNotification.alertBody = @"applicationDidEnterBackground";
	theNotification.hasAction = NO;
	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];
    }

- (void)applicationWillEnterForeground:(UIApplication *)application
    {
	UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
	theNotification.alertBody = @"applicationWillEnterForeground";
	theNotification.hasAction = NO;
	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];
    }

- (void)applicationDidBecomeActive:(UIApplication *)application
    {
	UILocalNotification *theNotification = [[UILocalNotification alloc] init];
	theNotification.alertBody = @"applicationDidBecomeActive";
	theNotification.hasAction = NO;
	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];
    }

- (void)applicationWillTerminate:(UIApplication *)application
    {
	UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
	theNotification.alertBody = @"applicationWillTerminate";
	theNotification.hasAction = NO;
	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];
    }

- (IBAction)bump:(id)inSender
	{
//	[[CBumpManager sharedInstance] bump:NULL];
	}

@end

