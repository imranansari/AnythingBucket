//
//  CPosting_CouchDBExtensions.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting_CouchDBExtensions.h"

#import "CUserNotificationManager.h"
#import "CBetterLocationManager.h"
#import "CAnythingDBServer.h"
#import "CLLocation_Extensions.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBAttachment.h"
#import "CCouchDBDocument.h"

@implementation CPosting (CPosting_CouchDBExtensions)

- (void)postWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
    {
    NSMutableDictionary *theDocument = [NSMutableDictionary dictionary];
    
    [theDocument setObject:@"posting" forKey:@"type"];
    [theDocument setObject:self.title forKey:@"title"];
    [theDocument setObject:self.body  forKey:@"body"];
    
    CLLocation *theLocation = [CBetterLocationManager instance].location;
    if (theLocation && theLocation.stale == NO)
        {
        NSMutableDictionary *theLocationDictionary = [NSMutableDictionary dictionary];
        [theLocationDictionary setObject:[NSNumber numberWithDouble:theLocation.coordinate.latitude] forKey:@"latitude"];
        [theLocationDictionary setObject:[NSNumber numberWithDouble:theLocation.coordinate.longitude] forKey:@"longitude"];

        [theDocument setObject:theLocationDictionary forKey:@"location"];
        }
        
    [theDocument setObject:self.tags forKey:@"tags"];
    
    id theSuccessHandler = ^(CCouchDBDocument *inDocument) {
        
//        for (CCouchDBAttachment *theAttachment in self.attachments)
//            {
//            [inDocument addAttachment:theAttachment];
//            }

        if (inSuccessHandler)
            {
            inSuccessHandler(inDocument);
            }
        };
    
    [[CAnythingDBServer sharedInstance].database createDocument:theDocument successHandler:theSuccessHandler failureHandler:inFailureHandler];
    }

@end
