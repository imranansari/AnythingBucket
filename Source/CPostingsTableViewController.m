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
#import "CCouchDBView.h"
#import "CTestViewController.h"
#import "CPosting.h"
#import "CAnythingDBModel.h"
#import "Bump.h"

@implementation CPostingsTableViewController

- (void)viewDidLoad
	{
	[super viewDidLoad];
    
    self.managedObjectContext = [CAnythingDBModel instance].managedObjectContext;
    
    NSFetchRequest *theFetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    theFetchRequest.entity = [NSEntityDescription entityForName:[CPosting entityName] inManagedObjectContext:[CAnythingDBModel instance].managedObjectContext];
    theFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchRequest = theFetchRequest;

	self.clearsSelectionOnViewWillAppear = NO;

	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}

- (void)viewWillAppear:(BOOL)animated
	{
	[super viewWillAppear:animated];

    CouchDBSuccessHandler theSuccessHandler = ^(id inParameter) {
        NSManagedObjectContext *theContext = [CAnythingDBModel instance].managedObjectContext;
        
        id theHandler = ^(void) {
            NSError *theError = NULL;
            for (CCouchDBDocument *theDocument in inParameter)
                {
                NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"externalID == %@", theDocument.identifier];
                BOOL theWasCreatedFlag = NO;
                CPosting *thePosting = [theContext fetchObjectOfEntityForName:[CPosting entityName] predicate:thePredicate createIfNotFound:YES wasCreated:&theWasCreatedFlag error:&theError];
                if (theWasCreatedFlag == YES)
                    {
                    thePosting.externalID = theDocument.identifier;
                    }
					
				NSString *theTitle = [theDocument.content objectForKey:@"title"];
				if (theTitle != NULL && theTitle != (id)[NSNull null])
					{
					thePosting.title = [theDocument.content objectForKey:@"title"];
					}
                }
            };
        
        NSError *theError = NULL;
        if ([theContext performTransaction:theHandler error:&theError] == NO)
            {
            NSLog(@"ERROR OCCURED: %@", theError);
            }
        };

    CCouchDBView *theView = [[[CCouchDBView alloc] initWithDatabase:[CAnythingDBServer sharedInstance].database identifier:@"_design/api"] autorelease];
    
    [theView fetchViewNamed:@"all-postings" options:NULL withSuccessHandler:theSuccessHandler failureHandler:^(NSError *inError) { NSLog(@"Error: %@", inError); }];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return(interfaceOrientation == UIInterfaceOrientationPortrait);
	}

#pragma mark -

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
		{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
    CPosting *thePosting = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
//    CCouchDBDocument *theDocument = [self.postings objectAtIndex:indexPath.row];
    
	cell.textLabel.text = thePosting.title;
    return cell;
	}
    
#pragma mark -


@end

