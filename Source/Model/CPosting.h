//
//  CPosting.h
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 10/22/10
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#pragma mark begin emogenerator forward declarations
#pragma mark end emogenerator forward declarations

/** Posting */
@interface CPosting : NSManagedObject {
}

#pragma mark begin emogenerator accessors

+ (NSString *)entityName;

// Attributes
@property (readwrite, retain) NSString *body;
@property (readwrite, retain) NSString *tags;
@property (readwrite, retain) NSString *title;

// Relationships

#pragma mark end emogenerator accessors

@end
