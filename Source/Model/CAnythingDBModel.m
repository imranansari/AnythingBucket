//
//  CAnythingDBModel.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CAnythingDBModel.h"

#import "CTrundleIncrementalStore.h"

static CAnythingDBModel *gInstance = NULL;

@implementation CAnythingDBModel

+ (CAnythingDBModel *)instance
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
    if ((self = [super init]) != NULL)
        {
        self.name = @"Model";

        self.storeType = [CTrundleIncrementalStore storeType];
        self.persistentStoreURL = [NSURL URLWithString:@"http://foo"];


//        self.storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:
//            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
//            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
//            NULL];
        }
    return(self);
    }

@end
