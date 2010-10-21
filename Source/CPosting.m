//
//  CPosting.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/17/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting.h"

#import "CUserNotificationManager.h"
#import "CBetterLocationManager.h"
#import "CAnythingDBServer.h"
#import "CLLocation_Extensions.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBAttachment.h"
#import "CCouchDBDocument.h"

@implementation CPosting

@synthesize document;
@synthesize attachments;
@synthesize tags;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        tags = [[NSMutableArray alloc] init];
        }
    return(self);
    }

- (void)dealloc
    {
    [document release];
    document = NULL;
    [attachments release];
    attachments = NULL;
    [tags release];
    tags = NULL;
    //
    [super dealloc];
    }

- (void)postWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
    {
    NSMutableDictionary *theDocument = [[self.document mutableCopy] autorelease];
    
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
        
        for (CCouchDBAttachment *theAttachment in self.attachments)
            {
            [inDocument addAttachment:theAttachment];
            }

        if (inSuccessHandler)
            {
            inSuccessHandler(inDocument);
            }
        };
    
    [[CAnythingDBServer sharedInstance].database createDocument:theDocument successHandler:theSuccessHandler failureHandler:inFailureHandler];
    }

@end
