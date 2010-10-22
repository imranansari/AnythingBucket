//
//  CMainNavigationController.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMainNavigationController.h"

#import "CTestViewController.h"
#import "CPostViewController.h"

@implementation CMainNavigationController

- (IBAction)pageCurl:(id)inSender
    {
    CTestViewController *theViewController = [[[CTestViewController alloc] init] autorelease];
    
//    theViewController.view.frame = [self.view convertRect:self.topViewController.view.bounds toView:self.topViewController.view.window];

    CGRect theFrame = theViewController.view.frame;
    theFrame.origin.y -= 100;
    theViewController.view.frame = theFrame;

    NSLog(@"%@", NSStringFromCGRect(theViewController.view.frame));
    NSLog(@"%@", NSStringFromCGRect(self.topViewController.view.bounds));

    theViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    theTestViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    NSLog(@"%@", self.topViewController);
    theViewController.view.frame = self.topViewController.view.bounds;
    [self.topViewController presentModalViewController:theViewController animated:YES];
    }


- (IBAction)post:(id)inSender
	{
	CPostViewController *theViewController = [[[CPostViewController alloc] init] autorelease];
    
	UINavigationController *theNavigationController = [[[UINavigationController alloc] initWithRootViewController:theViewController] autorelease];
	
	[self presentModalViewController:theNavigationController animated:YES];
	}


@end
