//
//  CGenericOverlay.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 01/05/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface CGenericOverlay : NSObject <MKOverlay> {

}

@property (readwrite, nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (readwrite, nonatomic, assign) MKMapRect boundingMapRect;


@end
