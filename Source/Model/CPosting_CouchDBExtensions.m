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
#import "CCouchDBSession.h"
#import "CCouchDBDocument.h"
#import "CAttachment.h"
#import "CObjectTranscoder.h"
#import "CURLOperation.h"

@implementation CPosting (CPosting_CouchDBExtensions)

- (void)postWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
    {
    CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] init] autorelease];
    id theDocument = [theTranscoder transcodedObjectForObject:self error:NULL];
    
    theDocument = [[theDocument mutableCopy] autorelease];

    [theDocument setObject:@"posting" forKey:@"type"];

    id theSuccessHandler = ^(CCouchDBDocument *inDocument) {
        
		self.externalID = inDocument.identifier;

		
        for (CAttachment *theAttachment in self.attachments)
            {
            CCouchDBAttachment *theCouchAttachment = [[[CCouchDBAttachment alloc] initWithIdentifier:theAttachment.identifier contentType:theAttachment.contentType data:theAttachment.data] autorelease];
            
            [inDocument addAttachment:theCouchAttachment];
            }

        if (inSuccessHandler)
            {
            inSuccessHandler(inDocument);
            }
        };
    
    CURLOperation *theOperation = [[CAnythingDBServer sharedInstance].anythingBucketDatabase operationToCreateDocument:theDocument successHandler:theSuccessHandler failureHandler:inFailureHandler];
	[[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
	
	
    }

@end
