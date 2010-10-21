//
//  CAnythingDBServer.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CAnythingDBServer.h"

#import "CouchDBClientConstants.h"

static CAnythingDBServer *gInstance = NULL;

@interface CAnythingDBServer ()
@property (readwrite, nonatomic, retain) CCouchDBDatabase *database;
@end

#pragma mark -

@implementation CAnythingDBServer

@synthesize database;

+ (CAnythingDBServer *)sharedInstance
{
@synchronized(self)
	{
	if (gInstance == NULL)
		{
		gInstance = [[self alloc] init];
		}
	}
return(gInstance);
}

- (id)init
    {
    if ((self = [super initWithSession:NULL URL:[NSURL URLWithString:@"http://touchcode.couchone.com:5984"]]) != NULL)
        {
		database = [self databaseNamed:@"anything-db"];
		
        if (database == NULL)
            {
            CouchDBSuccessHandler theSuccessHandler = ^(id inParameter) {
                self.database = inParameter;
                };
            CouchDBFailureHandler theFailureHandler = ^(NSError *inError) {
                if (inError.domain == kCouchErrorDomain && inError.code == CouchDBErrorCode_NoDatabase)
                    {
                    [self createDatabaseNamed:@"anything-db" withSuccessHandler:theSuccessHandler failureHandler:NULL];
                    }
                };
            [self fetchDatabaseNamed:@"anything-db" withSuccessHandler:theSuccessHandler failureHandler:theFailureHandler];
            }
        }
    return(self);
    }
    
- (void)dealloc
    {
    [database release];
    database = NULL;
    //
    [super dealloc];
    }


@end
