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
    theFetchRequest.entity = [NSEntityDescription entityForName:[CPosting entityName] inManagedObjectContext:[CAnythingDBModel instance].managedObjectContext];
	theFetchRequest.predicate = [NSPredicate predicateWithFormat:@"externalID != NULL"];
    theFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchRequest = theFetchRequest;

	self.clearsSelectionOnViewWillAppear = NO;

	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}

- (void)viewWillAppear:(BOOL)animated
	{
	[super viewWillAppear:animated];

	CCouchDBDatabase *theDatabase = [CAnythingDBServer sharedInstance].anythingBucketDatabase;
	
	CouchDBFailureHandler theFailureHandler = ^(NSError *inError) {
		NSLog(@"CouchDB Failure: %@", inError);
		};
	
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
			theFailureHandler(theError);
			return;
            }

		CouchDBSuccessHandler theSuccessHandler = (id)^(id inParameter) {
			id theCreateTransaction = ^(void) {
				for (CCouchDBDocument *theDocument in inParameter)
					{
					NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"externalID == %@", theDocument.identifier];
					BOOL theWasCreatedFlag = NO;
					NSError *theError = NULL;
					CPosting *thePosting = [theContext fetchObjectOfEntityForName:[CPosting entityName] predicate:thePredicate createIfNotFound:YES wasCreated:&theWasCreatedFlag error:&theError];
					if (theWasCreatedFlag == YES)
						{
						thePosting.externalID = theDocument.identifier;
						}
						
					@try
						{
						NSString *theTitle = [theDocument.content objectForKey:@"title"];
						if (theTitle != NULL && theTitle != (id)[NSNull null] && [theTitle isKindOfClass:[NSString class]])
							{
							thePosting.title = [theDocument.content objectForKey:@"title"];
							}
						}
					@catch (NSException * e)
						{
						NSLog(@"%@", e);
						}
					}
				};
			NSError *theError = NULL;
			if ([theContext performTransaction:theCreateTransaction error:&theError] == NO && theError != NULL)
				{
				theFailureHandler(theError);
				return;
				}
			};

		CURLOperation *theOperation = [theDatabase operationToBulkFetchDocuments:[inChangeSet.changedDocumentIdentifiers allObjects] options:NULL successHandler:theSuccessHandler failureHandler:theFailureHandler];
		[theDatabase.server.session.operationQueue addOperation:theOperation];
        };

	CURLOperation *theOperation = [theDatabase operationToFetchChanges:NULL successHandler:theSuccessHandler failureHandler:theFailureHandler];
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
	
#pragma mark -


@end

