//
//  COdometer.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 06/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface COdometer : NSObject

@property (readwrite, nonatomic, assign) CLLocationDistance distance;

- (void)processLocation:(CLLocation *)inLocation;

@end
