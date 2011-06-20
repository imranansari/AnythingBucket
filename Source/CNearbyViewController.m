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
#import "CMarqueeView.h"
#import "COdometer.h"

@interface CNearbyViewController () <MKMapViewDelegate>
@property (readwrite, nonatomic, retain) NSArray *locations;
@property (readwrite, nonatomic, retain) COdometer *odometer;
@end

#pragma mark -

@implementation CNearbyViewController

@synthesize mapView;
@synthesize marqueeView;

@synthesize locations;
@synthesize odometer;

- (void)viewDidLoad
    {
    [super viewDidLoad];
    
    self.odometer = [[COdometer alloc] init];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(locate:)];
	
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
//	CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(CCouchDBChangeSet *inChangeSet) {
//		self.locations = [inChangeSet.changedDocuments allObjects];
//
//		NSDictionary *theFirstLocation = [self.locations objectAtIndex:0];
//		CGenericOverlay *theOverlay = [[CGenericOverlay alloc] init];
//		theOverlay.boundingMapRect = MKMapRectWorld;
//		theOverlay.coordinate = (CLLocationCoordinate2D){
//			.latitude = [[theFirstLocation valueForKeyPath:@"location.coordinate.latitude"] doubleValue],
//			.longitude = [[theFirstLocation valueForKeyPath:@"location.coordinate.longitude"] doubleValue],
//			};
//		dispatch_async(dispatch_get_main_queue(), 
//			^(void) {
//				NSLog(@"ADDING OVERLAY");
//				[self.mapView addOverlay:theOverlay];
//				});
//		};
//	
//	CURLOperation *theOperation = [[CAnythingDBServer sharedInstance].locationsDatabase operationToFetchChanges:[NSDictionary dictionaryWithObject:@"true" forKey:@"include_docs"] successHandler:theSuccessHandler failureHandler:NULL];
//	[[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
    }

- (void)locate:(id)inSender
    {
    if (self.mapView.userTrackingMode == MKUserTrackingModeFollow)
        self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    else
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
    {

    CLLocation *theLocation = userLocation.location;

    [self.odometer processLocation:theLocation];

    
    CLLocationSpeed theSpeed = theLocation.speed;
    theSpeed *= 100.0 / 2.54 / 12.0 / 3.0 / 1760.0;
    theSpeed *= 3600.0;
    
    NSString *theLocalizedSpeed = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:theSpeed] numberStyle:NSNumberFormatterDecimalStyle];
    

    self.marqueeView.text = [NSString stringWithFormat:@"Speed: %@ mph, Accuracy: %g. Distance: %g", theLocalizedSpeed, theLocation.horizontalAccuracy, self.odometer.distance];
    }

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
    {
    NSLog(@"DID SELECT X: %@", view);
    }

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
    {
    NSLog(@"DID SELECT: %@", view);
    }


//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
//	{
//	CLLocationCoordinate2D *theLocations = calloc([self.locations count], sizeof(CLLocationCoordinate2D));
//	__block CLLocationCoordinate2D *P = theLocations;
//	[self.locations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		*P++ = (CLLocationCoordinate2D){
//			.latitude = [[obj valueForKeyPath:@"location.coordinate.latitude"] doubleValue],
//			.longitude = [[obj valueForKeyPath:@"location.coordinate.longitude"] doubleValue],
//			};
//		}];
//	
//	MKPolygon *thePolygon = [MKPolygon polygonWithCoordinates:theLocations count:[self.locations count]];
//	
//	MKPolygonView *thePolygonView = [[MKPolygonView alloc] initWithPolygon:thePolygon];
//	
//	free(theLocations);
//	
//	return(thePolygonView);
//	}

@end
