//
//  CTrundleIncrementalStore.m
//  Shoeboxes
//
//  Created by Jonathan Wight on 06/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTrundleIncrementalStore.h"

#import "Trundle.h"
#import "NSOperationQueue_Extensions.h"
#import "CAnythingDBServer.h"

@interface CTrundleIncrementalStore ()
@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, strong) CCouchDBDatabase *database;
@property (readwrite, strong) NSCache *documentCache;

@end

@implementation CTrundleIncrementalStore

@synthesize identifier;
@synthesize database;
@synthesize documentCache;

+ (void)load
    {
    [NSPersistentStoreCoordinator registerStoreClass:[self class] forStoreType:[self storeType]];
    }

+ (NSString *)storeType
    {
    return(@"TrundleIncrementalStore");
    }

+ (NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError **)error
    {
    return([NSDictionary dictionary]);
    }
    
+ (BOOL)setMetadata:(NSDictionary *)metadata forPersistentStoreWithURL:(NSURL*)url error:(NSError **)error;
    {
    return(YES);
    }

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)root configurationName:(NSString *)name URL:(NSURL *)url options:(NSDictionary *)options ;
	{
	if ((self = [super initWithPersistentStoreCoordinator:root configurationName:name URL:url options:options]) != NULL)
		{
        database = [CAnythingDBServer sharedInstance].anythingBucketDatabase;
        documentCache = [[NSCache alloc] init];
		}
	return(self);
	}

- (NSString *)type
    {
    return([[self class] storeType]);
    }

-(BOOL)loadMetadata:(NSError **)error
    {
    self.metadata = [NSDictionary dictionary];
    return(YES);
    }

- (id)executeRequest:(NSPersistentStoreRequest *)request withContext:(NSManagedObjectContext*)context error:(NSError **)error
    {
    if (request.requestType == NSFetchRequestType)
        {
        NSAssert([request isKindOfClass:[NSFetchRequest class]], @"Wrong class");
        NSFetchRequest *theFetchRequest = ((NSFetchRequest *)request);
        const NSFetchRequestResultType theResulttype = theFetchRequest.resultType;


        switch (theResulttype)
            {
            case NSManagedObjectResultType:
                {
//                NSLog(@"%@", theFetchRequest);
//                NSLog(@"%d", [NSThread isMainThread]);
//

                __block CCouchDBView *theView = NULL;

                CouchDBSuccessHandler theSuccessHandler = (id)^(CCouchDBView *view) {
                    theView = view;
                    };
                            
                id theOperation = [self.database operationToFetchAllDocumentsWithOptions:[NSDictionary dictionary] withSuccessHandler:theSuccessHandler failureHandler:NULL];
                [self.database.session.operationQueue addOperations:[NSArray arrayWithObject:theOperation] waitUntilFinished:YES];
                
                NSMutableArray *theObjects = [NSMutableArray array];
                for (CCouchDBViewRow *theRow in theView.rows)
                    {
                    CCouchDBDocument *theDocument = theRow.document;
                    
                    if ([theDocument.identifier rangeOfString:@"_design/"].location == 0)
                        continue;

                    NSManagedObjectID *theObjectID = [self newObjectIDForEntity:theFetchRequest.entity referenceObject:theDocument.identifier];
                    NSManagedObject *theObject = [context objectWithID:theObjectID];
                    
                    if ([self.documentCache objectForKey:theDocument.identifier] == NULL)
                        {
                        [self.documentCache setObject:[NSNull null] forKey:theDocument.identifier];
                        
                        CouchDBSuccessHandler theSuccessHandler = (id)^(CCouchDBDocument *inDocument) {
                            [self.documentCache setObject:theDocument forKey:inDocument];
                            };
                        id theOperation = [self.database operationToFetchDocument:theDocument options:NULL successHandler:theSuccessHandler failureHandler:NULL];
                        [self.database.session.operationQueue addOperation:theOperation];
                        }
                    
                    [theObjects addObject:theObject];
                    }
                return(theObjects);
                }
                break;
            case NSManagedObjectIDResultType:
                NSLog(@"TODO: NSManagedObjectIDResultType");
                break;
            case NSDictionaryResultType:
                NSLog(@"TODO: NSDictionaryResultType");
                break;
            case NSCountResultType:
                NSLog(@"TODO: NSCountResultType");
                break;
            }
        
        return([NSArray array]);
        }
    else if (request.requestType == NSSaveRequestType)
        {
        NSLog(@"TODO: NSSaveRequestType");
        }
    return(NULL);
    }

- (NSIncrementalStoreNode *)newValuesForObjectWithID:(NSManagedObjectID*)objectID withContext:(NSManagedObjectContext*)context error:(NSError**)error
    {
    NSString *theExternalIdentifier = [self referenceObjectForObjectID:objectID];
    
    CCouchDBDocument *theDocument = [self.documentCache objectForKey:theExternalIdentifier];
    if (theDocument == NULL)
        {
        NSLog(@"Error: no loady!");
        return(NULL);
        }

    NSIncrementalStoreNode *theNode = [[NSIncrementalStoreNode alloc] initWithObjectID:objectID withValues:theDocument.content version:1];
    return(theNode);
    }

- (id)newValueForRelationship:(NSRelationshipDescription*)relationship forObjectWithID:(NSManagedObjectID*)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error
    {
    return(NULL);
    }

+ (id)identifierForNewStoreAtURL:(NSURL*)storeURL
    {
    return(@"xyzzy");
    }

//- (NSArray*)obtainPermanentIDsForObjects:(NSArray*)array error:(NSError **)error
//    {
//    return(NULL);
//    }
//
//- (void)managedObjectContextDidRegisterObjectsWithIDs:(NSArray*)objectIDs
//    {
//    }
//
//- (void)managedObjectContextDidUnregisterObjectsWithIDs:(NSArray*)objectIDs
//    {
//    }

@end
