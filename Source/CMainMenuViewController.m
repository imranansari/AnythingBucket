//
//  CMainMenuViewController.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 12/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMainMenuViewController.h"

#import "CPostingsTableViewController.h"
#import "CNearbyViewController.h"

@implementation CMainMenuViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

- (IBAction)actionPostings
	{
	UIViewController *theViewController = [[[CPostingsTableViewController alloc] init] autorelease];
	[self.navigationController pushViewController:theViewController animated:YES];
	}

- (IBAction)actionPlaces
	{
	UIViewController *theViewController = [[[CNearbyViewController alloc] init] autorelease];
	[self.navigationController pushViewController:theViewController animated:YES];
	}

@end
