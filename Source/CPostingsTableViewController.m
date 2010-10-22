//
//  CPostingsTableViewController.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/20/10.
//  Copyright (c) 2010 toxicsoftware.com. All rights reserved.
//

#import "CPostingsTableViewController.h"

#import "CAnythingDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBDocument.h"
#import "CPostViewController.h"
#import "CCouchDBView.h"
#import "CTestViewController.h"

@implementation CPostingsTableViewController

@synthesize postings;

- (void)viewDidLoad
	{
	[super viewDidLoad];

	self.clearsSelectionOnViewWillAppear = NO;

	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}

- (void)viewWillAppear:(BOOL)animated
	{
	[super viewWillAppear:animated];

    CouchDBSuccessHandler theSuccessHandler = ^(id inParameter) {

		dispatch_async(dispatch_get_main_queue(), ^(void) {
			self.postings = inParameter;
			[self.tableView reloadData];
				});
        };

    CCouchDBView *theView = [[[CCouchDBView alloc] initWithDatabase:[CAnythingDBServer sharedInstance].database identifier:@"_design/api"] autorelease];
    
    [theView fetchViewNamed:@"all-postings" options:NULL withSuccessHandler:theSuccessHandler failureHandler:^(NSError *inError) { NSLog(@"Error: %@", inError); }];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return(interfaceOrientation == UIInterfaceOrientationPortrait);
	}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
    return(self.postings.count);
    }

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
		{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
    CCouchDBDocument *theDocument = [self.postings objectAtIndex:indexPath.row];
    
	cell.textLabel.text = [theDocument.content objectForKey:@"title"];
    return cell;
	}
    
#pragma mark -


@end

