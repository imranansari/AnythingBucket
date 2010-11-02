//
//  CAttachment.m
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 10/22/10
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CAttachment.h"

#pragma mark begin emogenerator forward declarations
#import "CPosting.h"
#pragma mark end emogenerator forward declarations

@implementation CAttachment

#pragma mark begin emogenerator accessors

+ (NSString *)entityName
{
return(@"Attachment");
}

@dynamic data;

@dynamic posting;

- (CPosting *)posting
{
[self willAccessValueForKey:@"posting"];
CPosting *theResult = [self primitiveValueForKey:@"posting"];
[self didAccessValueForKey:@"posting"];
return(theResult);
}

- (void)setPosting:(CPosting *)inPosting
{
[self willChangeValueForKey:@"posting"];
[self setPrimitiveValue:inPosting forKey:@"posting"];
[self didChangeValueForKey:@"posting"];
}

@dynamic contentType;

@dynamic identifier;

#pragma mark end emogenerator accessors

@end
