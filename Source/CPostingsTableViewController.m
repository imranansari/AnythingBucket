//
//  CPostingsTableViewController.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/20/10.
//  Copyright (c) 2010 toxicsoftware.com. All rights reserved.
//

#import "CPostingsTableViewController.h"

#import "NSManagedObjectContext_Extensions.h"

#import "CAnythingDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBDocument.h"
#import "CPostViewController.h"
#import "CPosting.h"
#import "CAnythingDBModel.h"
#import "CURLOperation.h"
#import "CCouchDBSession.h"
#import "CCouchDBChangeSet.h"
#import "CCouchDBView.h"
#import "CCouchDBViewRow.h"
#import "CErrorPresenter.h"

@implementation CPostingsTableViewController

@synthesize toolbar;

- (id)init
	{
	if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
		{
		}
	return(self);
	}

- (void)viewDidLoad
	{
	[super viewDidLoad];
    
    self.managedObjectContext = [CAnythingDBModel instance].managedObjectContext;
    
    NSFetchRequest *theFetchRequest = [[NSFetchRequest alloc] init];
    theFetchRequest.entity = [NSEntityDescription entityForName:[CPosting entityName] inManagedObjectContext:self.managedObjectContext];
	theFetchRequest.predicate = [NSPredicate predicateWithFormat:@"externalID != NULL"];
    theFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchRequest = theFetchRequest;

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];

	self.clearsSelectionOnViewWillAppear = NO;

	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}

- (void)viewWillAppear:(BOOL)animated
	{
	[super viewWillAppear:animated];

	CCouchDBDatabase *theDatabase = [CAnythingDBServer sharedInstance].anythingBucketDatabase;
	
    CouchDBSuccessHandler theSuccessHandler = (id)^(CCouchDBChangeSet *inChangeSet) {
        NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
        
        id theDeleteTransaction = ^(void) {
			NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"externalID in %@", inChangeSet.deletedDocumentsIdentifiers];
			NSError *theError = NULL;
			NSArray *theDeletedPostings = [theContext fetchObjectsOfEntityForName:[CPosting entityName] predicate:thePredicate error:&theError];
			for (CPosting *thePosting in theDeletedPostings)
				{
				[theContext deleteObject:thePosting];
				}
			};
        
        NSError *theError = NULL;
        if ([theContext performTransaction:theDeleteTransaction error:&theError] == NO && theError != NULL)
            {
			[[CLogging sharedInstance] logError:theError];
			return;
            }

		CouchDBSuccessHandler theSuccessHandler = (id)^(CCouchDBView *view) {
			id theCreateTransaction = ^(void) {
				for (CCouchDBViewRow *theRow in view.rows)
					{
                    CCouchDBDocument *theDocument = theRow.document;
                    
                    if ([theDocument.identifier rangeOfString:@"_design/"].location == 0)
                        continue;
                    
                    
					NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"externalID == %@", theDocument.identifier];
					BOOL theWasCreatedFlag = NO;
					NSError *theError = NULL;
					CPosting *thePosting = [theContext fetchObjectOfEntityForName:[CPosting entityName] predicate:thePredicate createIfNotFound:YES wasCreated:&theWasCreatedFlag error:&theError];
					if (theWasCreatedFlag == YES)
						{
						thePosting.externalID = theDocument.identifier;
						}
                    thePosting.externalRevision = theDocument.revision;
                    thePosting.title = [theDocument.content objectForKey:@"title"];

//                    CObjectTranscoder *theTranscoder = [[CObjectTranscoder alloc] init];
//                    id theDocument = [theTranscoder transcodedObjectForObject:self error:NULL];
//



					}
				};
			NSError *theError = NULL;
			if ([theContext performTransaction:theCreateTransaction error:&theError] == NO && theError != NULL)
				{
				[self presentError:theError];
				return;
				}
			};

		CURLOperation *theOperation = [theDatabase operationToBulkFetchDocuments:[inChangeSet.changedDocumentIdentifiers allObjects] options:NULL successHandler:theSuccessHandler failureHandler:NULL];
		[theDatabase.server.session.operationQueue addOperation:theOperation];
        };

	CURLOperation *theOperation = [theDatabase operationToFetchChanges:NULL successHandler:theSuccessHandler failureHandler:NULL];
	[theDatabase.server.session.operationQueue addOperation:theOperation];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return(interfaceOrientation == UIInterfaceOrientationPortrait);
	}

#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
		{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
    CPosting *thePosting = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
	cell.textLabel.text = thePosting.title;
    return cell;
	}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
	{
    CPosting *thePosting = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSLog(@"%@", thePosting);
	}
	
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
	{
	return(UITableViewCellEditingStyleDelete);
	}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
	{
	if (editingStyle == UITableViewCellEditingStyleDelete)
		{
        CPosting *thePosting = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        CCouchDBDatabase *theDatabase = [CAnythingDBServer sharedInstance].anythingBucketDatabase;
		CURLOperation *theOperation = [theDatabase operationToDeleteDocumentForIdentifier:thePosting.externalID revision:thePosting.externalRevision successHandler:^(id inParameter) { NSLog(@"DELETED"); [self.managedObjectContext performTransaction:^(void) { [self.managedObjectContext deleteObject:thePosting]; } error:NULL];
            } failureHandler:NULL];
		[theDatabase.server.session.operationQueue addOperation:theOperation];

//		NSManagedObject *theObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        [self.managedObjectContext performTransaction:^(void) {
//            [self.managedObjectContext deleteObject:theObject];
//            } error:NULL];
		}   
    else
        {
        [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
	}

    
#pragma mark -

//- (void)managedObjectContextDidSaveNotification:(NSNotification *)inNotification
//    {
//    NSSet *theDeletedObjects = [[inNotification userInfo] objectForKey:NSDeletedObjectsKey];
//    for (CPosting *thePosting in theDeletedObjects)
//        {
//        CCouchDBDatabase *theDatabase = [CAnythingDBServer sharedInstance].anythingBucketDatabase;
//		CURLOperation *theOperation = [theDatabase operationToDeleteDocumentForIdentifier:thePosting.externalID revision:thePosting.externalRevision successHandler:^(id inParameter) { NSLog(@"DELETED"); } failureHandler:NULL];
//		[theDatabase.server.session.operationQueue addOperation:theOperation];
//        }
//    }

@end

