//
//  CPosting_CouchDBExtensions.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting_CouchDBExtensions.h"

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
    CObjectTranscoder *theTranscoder = [[CObjectTranscoder alloc] init];
    id theDocument = [theTranscoder transcodedObjectForObject:self error:NULL];
    
    theDocument = [theDocument mutableCopy];

    [theDocument setObject:@"posting" forKey:@"type"];

    __block CPosting *_self = self;
    id theSuccessHandler = ^(CCouchDBDocument *inDocument) {
		self.externalID = inDocument.identifier;
        for (CAttachment *theAttachment in _self.attachments)
            {
            CCouchDBAttachment *theCouchAttachment = [[CCouchDBAttachment alloc] initWithIdentifier:theAttachment.identifier contentType:theAttachment.contentType data:theAttachment.data];

            CURLOperation *theOperation = [inDocument operationToAddAttachment:theCouchAttachment successHandler:NULL failureHandler:NULL];
            [[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
            }
        if (inSuccessHandler)
            {
            inSuccessHandler(inDocument);
            }
        _self = NULL;
        };
    
    CURLOperation *theOperation = [[CAnythingDBServer sharedInstance].anythingBucketDatabase operationToCreateDocument:theDocument successHandler:theSuccessHandler failureHandler:inFailureHandler];
	[[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
    }

@end
