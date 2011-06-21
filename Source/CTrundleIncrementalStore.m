//
//  CTrundleIncrementalStore.m
//  Shoeboxes
//
//  Created by Jonathan Wight on 06/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTrundleIncrementalStore.h"

#import "Trundle.h"

@interface CTrundleIncrementalStore ()
@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, strong) CCouchDBSession *session;
@property (readwrite, strong) CCouchDBServer *server;
@property (readwrite, strong) CCouchDBDatabase *database;
@end

@implementation CTrundleIncrementalStore

@synthesize identifier;
@synthesize session;
@synthesize server;
@synthesize database;

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
        session = [[CCouchDBSession alloc] init];
        server = [[CCouchDBServer alloc] initWithSession:session URL:[NSURL URLWithString:@"http://localhost:5984/"]];
        database = [[CCouchDBDatabase alloc] initWithServer:server name:@"coredata_test"];
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
        
        NSLog(@"%d %d", request.requestType, theResulttype);
        
        switch (theResulttype)
            {
            case NSManagedObjectResultType:
                {
                NSManagedObjectID *theObjectID = [self newObjectIDForEntity:theFetchRequest.entity referenceObject:@"FOO"];
                NSManagedObject *theObject = [context objectWithID:theObjectID];
//                [theObject setValue:[NSDate date] forKey:@"posted"];
                return([NSArray arrayWithObject:theObject]);
                }
                break;
            case NSManagedObjectIDResultType:
                break;
            case NSDictionaryResultType:
                break;
            case NSCountResultType:
                break;
            }
        
        return([NSArray array]);
        }
    else if (request.requestType == NSSaveRequestType)
        {
        NSLog(@"SAVE");
        }
    return(NULL);
    }

- (NSIncrementalStoreNode *)newValuesForObjectWithID:(NSManagedObjectID*)objectID withContext:(NSManagedObjectContext*)context error:(NSError**)error
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSDate date], @"posted",
        NULL];
    NSIncrementalStoreNode *theNode = [[NSIncrementalStoreNode alloc] initWithObjectID:objectID withValues:theDictionary version:1];
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
