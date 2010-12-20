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
#import "MPOAuthAPI.h"
#import "CPersistentOperationQueue.h"
#import "CCodingCouchDBURLOperation.h"

@interface CLocationTracker () <CLLocationManagerDelegate>
@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;
@property (readwrite, nonatomic, retain) CCouchDBServer *server;
@property (readwrite, nonatomic, retain) CCouchDBDatabase *database;
- (void)start;
@end

@implementation CLocationTracker

@synthesize locationManager;
@synthesize server;
@synthesize database;

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
	CLLocationManager *theLocationManager = [[[CLLocationManager alloc] init] autorelease];

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

	NSLog(@"%@", theDefaults);

	theLocationManager.delegate = self;
	theLocationManager.purpose = @"For whatever the hell I want";
	theLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	theLocationManager.distanceFilter = 100.0;
	[theLocationManager startUpdatingLocation];
	
	self.locationManager = theLocationManager;
	
	self.server = [[[CCouchDBServer alloc] initWithSession:NULL URL:[NSURL URLWithString:@"http://touchcode.couchone.com"]] autorelease];
	self.server.session.URLOperationClass = [CCodingCouchDBURLOperation class];
	self.server.session.operationQueue = [[[CPersistentOperationQueue alloc] initWithName:@"locations"] autorelease];
//	self.server.URLCredential = [NSURLCredential credentialWithUser:@"user" password:@"password" persistence:NSURLCredentialPersistenceNone];
	self.database = [[[CCouchDBDatabase alloc] initWithServer:self.server name:@"locations"] autorelease];
	}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
	{
	NSLog(@"DID UPDATE TO LOC: %@", newLocation);
	
//	UILocalNotification *theNotification = [[[UILocalNotification alloc] init] autorelease];
//	theNotification.alertBody = @"Yo location changed";
//	theNotification.hasAction = YES;
//	theNotification.alertAction = @"Do something";
//	[[UIApplication sharedApplication] presentLocalNotificationNow:theNotification];

	NSMutableDictionary *theDocument = [NSMutableDictionary dictionary];
	[theDocument setObject:[NSDate date] forKey:@"timestamp"];

    CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] init] autorelease];
    id theLocationDocument = [theTranscoder transcodedObjectForObject:newLocation error:NULL];

	[theDocument setObject:theLocationDocument forKey:@"location"];

    id theSuccessHandler = ^(CCouchDBDocument *inDocument) {
		NSLog(@"Posted location: %@", inDocument);
        };
    
	id theFailureHandler = ^(NSError *inError) {
		NSLog(@"Failed to post location: %@", inError);
		};
	
    CURLOperation *theOperation = [self.database operationToCreateDocument:theDocument successHandler:theSuccessHandler failureHandler:theFailureHandler];
	[self.server.session.operationQueue addOperation:theOperation];
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
	NSLog(@"DID CHANGE AUTH STATUS");
	}


@end