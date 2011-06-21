//
//  CPosting.m
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 10/22/10
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting.h"

#pragma mark begin emogenerator forward declarations
#import "CAttachment.h"
#pragma mark end emogenerator forward declarations

@implementation CPosting

#pragma mark begin emogenerator accessors

+ (NSString *)entityName
{
return(@"Posting");
}

@dynamic location;

@dynamic title;

@dynamic created;

@dynamic attachments;

- (NSMutableSet *)attachments
{
return([self mutableSetValueForKey:@"attachments"]);
}

@dynamic modified;

@dynamic body;

@dynamic tags;

@dynamic externalID;

@dynamic externalRevision;

#pragma mark end emogenerator accessors

@end
