//
//  CBumpManager.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 11/01/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CBumpManager.h"

#import "Bump.h"
#import "BUMP_API_KEY.h"

static CBumpManager *gInstance = NULL;

@interface CBumpManager () <BumpDelegate>
@property (readwrite, nonatomic, retain) Bump *bump;
@end

@implementation CBumpManager

@synthesize bump;

+ (CBumpManager *)sharedInstance
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
		bump = [[Bump alloc] init];
		[bump configAPIKey:BUMP_API_KEY];
		bump.delegate = self;
		}
	return(self);
	}

- (void)dealloc
	{
	bump.delegate = NULL;
	[bump release];
	bump = NULL;
	//
	[super dealloc];
	}

#pragma mark -

- (void)bump:(id)inParameter;
	{
	[self.bump connect];
	}

- (void)bumpDidConnect
	{
	NSLog(@"DID CONNECT");
	[self.bump send:[@"Hello world" dataUsingEncoding:NSUTF8StringEncoding]];
	}

- (void)bumpDidDisconnect:(BumpDisconnectReason)reason
	{
	NSLog(@"DID DISCONNECT: %d", reason);
	}

- (void)bumpConnectFailed:(BumpConnectFailedReason)reason
	{
	NSLog(@"bumpConnectFailed: %d", reason);
	}

- (void)bumpDataReceived:(NSData *)chunk
	{
	NSLog(@"bumpDataReceived: %@", chunk);
	NSString *theString = [[[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding] autorelease];
	[[[[UIAlertView alloc] initWithTitle:NULL message:theString delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL] autorelease] show];
	
	}
	
- (void)bumpSendSuccess
	{
	NSLog(@"bumpSendSuccess");
	}

//- (void)bumpContactExchangeSuccess:(BumpContact *)contact
//	{
//	
//	}
//	
//- (void)bumpShareAppLinkSent;


@end
