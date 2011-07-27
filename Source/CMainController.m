//
//  AnythingDBAppDelegate.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMainController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "CAnythingDBServer.h"
//#import "CBumpManager.h"
#import "CLocationTracker.h"
#import "NSUserDefaults_AnythingBucketExtensions.h"
#import "UIAlertView_BlocksExtensions.h"
#import "CJSONFileLoggingDestination.h"
#import "CMemoryLogDestination.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBSession.h"

#import <objc/runtime.h>

@interface CMainController () <UIApplicationDelegate, UITabBarControllerDelegate>
@end

#pragma mark -

@implementation CMainController

@synthesize window;

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
    {
    }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];

    // #########################################################################

    [[CLogging sharedInstance] addDefaultDestinations];

    NSError *theError = NULL;
    NSURL *theLogFile = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:0 create:YES error:&theError];
    theLogFile = [theLogFile URLByAppendingPathComponent:@"Test.json"];
    [[CLogging sharedInstance] addDestination:[[CJSONFileLoggingDestination alloc] initWithURL:theLogFile]];

    [[CLogging sharedInstance] addDestination:[CMemoryLogDestination sharedInstance]];

    // #########################################################################
    
    LogDict_(LoggingLevel_DEBUG, launchOptions, @"Application did launch");

    // #########################################################################

    [self.window makeKeyAndVisible];

    // #########################################################################
    
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

    // #########################################################################

//    CCouchDBDatabase *theDatabase = [[CCouchDBDatabase alloc] initWithURL:[NSURL URLWithString:@"https://touchcode.couchone.com/applications"]];
//    CouchDBSuccessHandler theSuccessHandler = (id)^(id inParameter) { NSLog(@"%@", inParameter); };
//    id theOperation = [theDatabase operationToFetchDocumentForIdentifier:[NSBundle mainBundle].bundleIdentifier options:NULL successHandler:theSuccessHandler failureHandler:NULL];
//    [theDatabase.session.operationQueue addOperation:theOperation];
    
    // #########################################################################
    
    [CAnythingDBServer sharedInstance];

    // #########################################################################
	
	[CLocationTracker sharedInstance];
	
    return(YES);
    }

- (void)applicationWillResignActive:(UIApplication *)application
    {
    LogInformation_(@"applicationWillResignActive:");
    }

- (void)applicationDidEnterBackground:(UIApplication *)application
    {
    LogInformation_(@"applicationDidEnterBackground:");
    }

- (void)applicationWillEnterForeground:(UIApplication *)application
    {
    LogInformation_(@"applicationWillEnterForeground:");
    }

- (void)applicationDidBecomeActive:(UIApplication *)application
    {
    LogInformation_(@"applicationDidBecomeActive:");
    }

- (void)applicationWillTerminate:(UIApplication *)application
    {
    LogInformation_(@"applicationWillTerminate:");
    }

- (IBAction)bump:(id)inSender
	{
//	[[CBumpManager sharedInstance] bump:NULL];
	}

@end

