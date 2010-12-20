//
//  CNearbyViewController.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CNearbyViewController.h"

#import <MapKit/MapKit.h>

@interface CNearbyViewController ()
@end

#pragma mark -

@implementation CNearbyViewController

@synthesize mapView;

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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(locate:)] autorelease];
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

@end
