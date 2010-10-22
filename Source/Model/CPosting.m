//
//  CPosting.m
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 10/22/10
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting.h"

#pragma mark begin emogenerator forward declarations
#pragma mark end emogenerator forward declarations

@implementation CPosting

#pragma mark begin emogenerator accessors

+ (NSString *)entityName
{
return(@"Posting");
}

@dynamic body;

@dynamic tags;

@dynamic title;

#pragma mark end emogenerator accessors

@end
