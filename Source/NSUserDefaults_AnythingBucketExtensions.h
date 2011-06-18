//
//  NSUserDefaults_AnythingBucketExtensions.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 12/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NSUserDefaults_AnythingBucketExtensions)

@property (readonly, nonatomic, retain) NSURL *serverURL;
@property (readwrite, nonatomic, retain) NSString *username;
@property (readwrite, nonatomic, retain) NSString *password;

@end
