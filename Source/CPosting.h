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
    NSString *title;
    NSString *body;
    NSArray *tags;
    NSArray *attachments;
}

@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSString *body;
@property (readwrite, nonatomic, retain) NSArray *tags;
@property (readwrite, nonatomic, retain) NSArray *attachments;

- (void)postWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

@end
