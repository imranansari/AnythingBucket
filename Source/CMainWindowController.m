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

@interface CMainWindowController () <UIApplicationDelegate, UITabBarControllerDelegate>
@end

#pragma mark -

@implementation CMainWindowController

@synthesize window;

- (void)dealloc
    {
    [window release];
    [super dealloc];
    }

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
    {
    }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
	NSLog(@"%@", launchOptions);
							                        
    [window makeKeyAndVisible];
    [CAnythingDBServer sharedInstance];
	
	[CLocationTracker sharedInstance];
	
    return(YES);
    }

- (void)applicationWillResignActive:(UIApplication *)application
    {
    }

- (void)applicationDidEnterBackground:(UIApplication *)application
    {
    }

- (void)applicationWillEnterForeground:(UIApplication *)application
    {
    }

- (void)applicationDidBecomeActive:(UIApplication *)application
    {
    }

- (void)applicationWillTerminate:(UIApplication *)application
    {
    }

- (IBAction)bump:(id)inSender
	{
//	[[CBumpManager sharedInstance] bump:NULL];
	}

@end

