//
//  CNearbyViewController.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CNearbyViewController.h"

#import <MapKit/MapKit.h>

#import "CAnythingDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBSession.h"
#import "CURLOperation.h"
#import "CCouchDBChangeSet.h"
#import "CGenericOverlay.h"

@interface CNearbyViewController ()
@property (readwrite, nonatomic, retain) NSArray *locations;
@end

#pragma mark -

@implementation CNearbyViewController

@synthesize mapView;
@synthesize locations;

- (id)init
	{
	if ((self = [super initWithNibName:NULL bundle:NULL]) != NULL)
		{
		}
	return(self);
	}

- (void)viewDidLoad
    {
    [super viewDidLoad];

    self.title = @"Nearby";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(locate:)];
	
	CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(CCouchDBChangeSet *inChangeSet) {
		self.locations = [inChangeSet.changedDocuments allObjects];


		NSDictionary *theFirstLocation = [self.locations objectAtIndex:0];
		CGenericOverlay *theOverlay = [[CGenericOverlay alloc] init];
		theOverlay.boundingMapRect = MKMapRectWorld;
		theOverlay.coordinate = (CLLocationCoordinate2D){
			.latitude = [[theFirstLocation valueForKeyPath:@"location.coordinate.latitude"] doubleValue],
			.longitude = [[theFirstLocation valueForKeyPath:@"location.coordinate.longitude"] doubleValue],
			};
		dispatch_async(dispatch_get_main_queue(), 
			^(void) {
				NSLog(@"ADDING OVERLAY");
				[self.mapView addOverlay:theOverlay];
				});
		};
	
	
	CURLOperation *theOperation = [[CAnythingDBServer sharedInstance].locationsDatabase operationToFetchChanges:[NSDictionary dictionaryWithObject:@"true" forKey:@"include_docs"] successHandler:theSuccessHandler failureHandler:^(NSError * inError) { NSLog(@"Error: %@", inError); }];
	[[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
    }

- (void)locate:(id)inSender
    {
    NSLog(@"locate: %@", self.mapView);
    self.mapView.showsUserLocation = YES;
    }
    
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
    {
    MKCoordinateRegion theRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    theRegion = [self.mapView regionThatFits:theRegion];
    [self.mapView setRegion:theRegion animated:YES];
    }

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
	{
	CLLocationCoordinate2D *theLocations = calloc([self.locations count], sizeof(CLLocationCoordinate2D));
	__block CLLocationCoordinate2D *P = theLocations;
	[self.locations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		*P++ = (CLLocationCoordinate2D){
			.latitude = [[obj valueForKeyPath:@"location.coordinate.latitude"] doubleValue],
			.longitude = [[obj valueForKeyPath:@"location.coordinate.longitude"] doubleValue],
			};
		}];
	
	MKPolygon *thePolygon = [MKPolygon polygonWithCoordinates:theLocations count:[self.locations count]];
	
	MKPolygonView *thePolygonView = [[MKPolygonView alloc] initWithPolygon:thePolygon];
	
	free(theLocations);
	
	return(thePolygonView);
	}

@end
