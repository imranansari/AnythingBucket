//
//  CLocationTracker.m
//  CoreLocationTracker
//
//  Created by Jonathan Wight on 12/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLocationTracker.h"

#import <CoreLocation/CoreLocation.h>

#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBSession.h"
#import "CURLOperation.h"
#import "CObjectTranscoder.h"
#import "CPersistentOperationQueue.h"
#import "CCodingCouchDBURLOperation.h"
#import "NSUserDefaults_AnythingBucketExtensions.h"
#import "CAnythingDBServer.h"

@interface CLocationTracker () <CLLocationManagerDelegate>
@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;
- (void)start;
@end

@implementation CLocationTracker

@synthesize locationManager;

+ (CLocationTracker *)sharedInstance
	{
	static id sSharedInstance = NULL;
	static dispatch_once_t sPredicate = 0;
	dispatch_once(&sPredicate, ^(void) { sSharedInstance = [[self alloc] init]; });
	return(sSharedInstance);
	}

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
		[self start];
		}
	return(self);
	}

#pragma mark -

- (void)start
	{
	CLLocationManager *theLocationManager = [[CLLocationManager alloc] init];

//	NSDictionary *theCredentials = [NSDictionary dictionaryWithObjectsAndKeys:	@"dummy-consumer-key", kMPOAuthCredentialConsumerKey,
//																				@"dummy-consumer-secret", kMPOAuthCredentialConsumerSecret,
//																				nil];
//	NSURL *theAuthURL = [NSURL URLWithString:@"https://touchcode.couchone.com"];
//	MPOAuthAPI *theOAuthAPI = [[[MPOAuthAPI alloc] initWithCredentials:theCredentials authenticationURL:theAuthURL andBaseURL:theAuthURL autoStart:YES] autorelease];
//	NSLog(@"%@", theOAuthAPI);


	NSMutableDictionary *theDefaults = [NSMutableDictionary dictionary];
	for (NSString *theKey in [NSArray arrayWithObjects:@"purpose", @"distanceFilter", @"desiredAccuracy", @"location", @"headingFilter", @"headingOrientation", @"heading", @"maximumRegionMonitoringDistance", @"monitoredRegions", NULL])
		{
		id theValue = [theLocationManager valueForKey:theKey];
		if (theValue != NULL)
			{
			[theDefaults setObject:theValue forKey:theKey];
			}
		}

	theLocationManager.delegate = self;
	theLocationManager.purpose = @"For whatever the hell I want";
	theLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	theLocationManager.distanceFilter = 100.0;
	[theLocationManager startUpdatingLocation];
	
	self.locationManager = theLocationManager;
	
	if ([NSUserDefaults standardUserDefaults].username.length == 0 || [NSUserDefaults standardUserDefaults].password == 0)
		{
		NSLog(@"No username or password.");
		}
	
	CPersistentOperationQueue *theOperationQueue = [[CPersistentOperationQueue alloc] initWithName:@"locations"];
	theOperationQueue.unhibernateBlock = ^(NSOperation *inOperation) {
		CCouchDBURLOperation *theOperation = (CCouchDBURLOperation *)inOperation;
		theOperation.successHandler = (CouchDBSuccessHandler)^(CCouchDBDocument *inDocument) {
//			LogInformation_(@"Posted location: %@", inDocument);
			};
		
		theOperation.failureHandler = ^(NSError *inError) {
			LogInformation_(@"Failed to post location: %@", inError);
			};

		};
	}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
	{
	LogInformation_(@"DID UPDATE TO LOC: %@", newLocation);
	
//	UILocalNotification *theNotification = [[[UILocalNotification alloc] init] autorelease];
//	theNotification.alertBody = @"Yo location changed";
//	theNotification.hasAction = YES;
//	theNotification.alertAction = @"Do something";
//	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];

	NSMutableDictionary *theDocument = [NSMutableDictionary dictionary];
	[theDocument setObject:[NSDate date] forKey:@"timestamp"];
	[theDocument setObject:@"location-update" forKey:@"type"];

    CObjectTranscoder *theTranscoder = [[CObjectTranscoder alloc] init];
    id theLocationDocument = [theTranscoder transcodedObjectForObject:newLocation error:NULL];

	[theDocument setObject:theLocationDocument forKey:@"location"];

    id theSuccessHandler = ^(CCouchDBDocument *inDocument) {
//		LogInformation_(@"Posted location: %@", inDocument);
        };
    
	id theFailureHandler = ^(NSError *inError) {
		LogInformation_(@"Failed to post location: %@", inError);
		};
	
    CURLOperation *theOperation = [[CAnythingDBServer sharedInstance].locationsDatabase operationToCreateDocument:theDocument successHandler:theSuccessHandler failureHandler:theFailureHandler];
	[[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
	}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
	{
	}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
	{
	return(YES);
	}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
	{
	}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
	{
	}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
	{
	}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
	{
	}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
	{
	}


@end
