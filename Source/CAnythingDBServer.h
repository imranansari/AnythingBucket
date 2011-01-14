//
//  CAnythingDBServer.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBServer.h"

@interface CAnythingDBServer : CCouchDBServer {
}

@property (readonly, nonatomic, retain) CCouchDBDatabase *anythingBucketDatabase;
@property (readonly, nonatomic, retain) CCouchDBDatabase *locationsDatabase;

+ (CAnythingDBServer *)sharedInstance;

@end
