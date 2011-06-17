//
//  NSUserDefaults_AnythingBucketExtensions.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 12/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSUserDefaults_AnythingBucketExtensions.h"


@implementation NSUserDefaults (NSUserDefaults_AnythingBucketExtensions)

+ (void)initialize
	{
	@autoreleasepool {
	
	NSDictionary *theRegistrationDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
		@"http://touchcode.couchone.com", @"ServerURL",
		NULL];
	
	[[self standardUserDefaults] registerDefaults:theRegistrationDefaults];
	
	}
	}

- (NSURL *)serverURL
	{
	return([NSURL URLWithString:[self objectForKey:@"ServerURL"]]);
	}

- (NSString *)username
	{
	return([self objectForKey:@"username"]);
	}

- (NSString *)password
	{
	return([self objectForKey:@"password"]);
	}

@end