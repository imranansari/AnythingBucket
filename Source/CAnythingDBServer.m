//
//  CAnythingDBServer.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CAnythingDBServer.h"

#import "NSManagedObjectContext_Extensions.h"

#import "CouchDBClientConstants.h"
#import "CAnythingDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBDocument.h"
#import "CCouchDBDesignDocument.h"
#import "CPosting.h"
#import "CAnythingDBModel.h"
#import "CURLOperation.h"
#import "CCouchDBSession.h"
#import "CCouchDBChangeSet.h"
#import "CURLOperation.h"
#import "NSUserDefaults_AnythingBucketExtensions.h"

static CAnythingDBServer *gInstance = NULL;

@interface CAnythingDBServer ()
@property (readwrite, nonatomic, retain) CCouchDBDatabase *anythingBucketDatabase;
@end

#pragma mark -

@implementation CAnythingDBServer

@synthesize anythingBucketDatabase;
@synthesize locationsDatabase;

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
    if ((self = [super initWithSession:NULL URL:[NSUserDefaults standardUserDefaults].serverURL]) != NULL)
        {
		self.URLCredential = [NSURLCredential credentialWithUser:[NSUserDefaults standardUserDefaults].username password:[NSUserDefaults standardUserDefaults].password persistence:NSURLCredentialPersistenceNone];


		anythingBucketDatabase = [self databaseNamed:@"anything-db"];
		locationsDatabase = [self databaseNamed:@"locations"];
		
        if (locationsDatabase == NULL)
            {
            CouchDBSuccessHandler theSuccessHandler = ^(id inParameter) {
                self.anythingBucketDatabase = inParameter;
                };
            CouchDBFailureHandler theFailureHandler = ^(NSError *inError) {
                if (inError.domain == kCouchErrorDomain && inError.code == CouchDBErrorCode_NoDatabase)
                    {
                    CURLOperation *theOperation = [self operationToCreateDatabaseNamed:@"anything-db" withSuccessHandler:theSuccessHandler failureHandler:NULL];
					[self.session.operationQueue addOperation:theOperation];
                    }
                };
            CURLOperation *theOperation = [self operationToCreateDatabaseNamed:@"anything-db" withSuccessHandler:theSuccessHandler failureHandler:theFailureHandler];
			[self.session.operationQueue addOperation:theOperation];
            }
        }
    return(self);
    }
    

#pragma mark -

- (void)fetchChangedPostings
	{
    CouchDBSuccessHandler theSuccessHandler = (id)^(CCouchDBChangeSet *inChangeSet) {
        NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
        
        id theTransaction = ^(void) {
		
			NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"externalID in %@", inChangeSet.deletedDocumentsIdentifiers];
			NSError *theError = NULL;
			NSArray *theDeletedPostings = [theContext fetchObjectsOfEntityForName:[CPosting entityName] predicate:thePredicate error:&theError];
			for (CPosting *thePosting in theDeletedPostings)
				{
				[theContext deleteObject:thePosting];
				}
				
			
		
//            NSError *theError = NULL;
//            for (CCouchDBDocument *theDocument in inParameter)
//                {
//                NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"externalID == %@", theDocument.identifier];
//                BOOL theWasCreatedFlag = NO;
//                CPosting *thePosting = [theContext fetchObjectOfEntityForName:[CPosting entityName] predicate:thePredicate createIfNotFound:YES wasCreated:&theWasCreatedFlag error:&theError];
//                if (theWasCreatedFlag == YES)
//                    {
//                    thePosting.externalID = theDocument.identifier;
//                    }
//					
//				NSString *theTitle = [theDocument.content objectForKey:@"title"];
//				if (theTitle != NULL && theTitle != (id)[NSNull null])
//					{
//					thePosting.title = [theDocument.content objectForKey:@"title"];
//					}
//                }
            };
        
        NSError *theError = NULL;
        if ([theContext performTransaction:theTransaction error:&theError] == NO && theError != NULL)
            {
            NSLog(@"ERROR OCCURED: %@", theError);
            }
        };

	CURLOperation *theOperation = [[CAnythingDBServer sharedInstance].anythingBucketDatabase operationToFetchChanges:NULL successHandler:theSuccessHandler failureHandler:^(NSError *inError) { NSLog(@"Error: %@", inError); }];
	[[CAnythingDBServer sharedInstance].session.operationQueue addOperation:theOperation];
	}

- (void)fetchPostings:(NSSet *)inDocumentIdentifiers
	{
	}


@end
