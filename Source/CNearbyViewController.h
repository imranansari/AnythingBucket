//
//  CNearbyViewController.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class CMarqueeView;

@interface CNearbyViewController : UIViewController {
}

@property (readwrite, nonatomic, retain) IBOutlet MKMapView *mapView;
@property (readwrite, nonatomic, retain) IBOutlet CMarqueeView *marqueeView;

@end
