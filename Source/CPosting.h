//
//  CPosting.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/17/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CouchDBClientTypes.h"

@interface CPosting : NSObject {
    NSDictionary *document;
    NSArray *attachments;
    NSArray *tags;
}

@property (readwrite, nonatomic, retain) NSDictionary *document;
@property (readwrite, nonatomic, retain) NSArray *attachments;
@property (readwrite, nonatomic, retain) NSArray *tags;

- (void)postWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

@end
