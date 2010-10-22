//
//  CPosting_CouchDBExtensions.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting.h"

#import "CouchDBClientTypes.h"

@interface CPosting (CPosting_CouchDBExtensions)

- (void)postWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

@end
