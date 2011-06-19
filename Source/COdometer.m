//
//  COdometer.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 06/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "COdometer.h"

@interface COdometer ()
@property (readwrite, nonatomic, retain) CLLocation *lastLocation;
@end

#pragma mark -

@implementation COdometer

@synthesize distance;

@synthesize lastLocation;

- (void)processLocation:(CLLocation *)inLocation
    {
    if (lastLocation != NULL)
        {
        self.distance += [inLocation distanceFromLocation:self.lastLocation];
        }
        
    self.lastLocation = inLocation;
    }

@end
