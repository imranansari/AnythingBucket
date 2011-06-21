//
//  CPosting.h
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 10/22/10
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#pragma mark begin emogenerator forward declarations
@class CAttachment;
#pragma mark end emogenerator forward declarations

/** Posting */
@interface CPosting : NSManagedObject {
}

#pragma mark begin emogenerator accessors

+ (NSString *)entityName;

// Attributes
@property (readwrite, retain) id location;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) NSDate *created;
@property (readwrite, retain) NSDate *modified;
@property (readwrite, retain) NSString *body;
@property (readwrite, retain) id tags;
@property (readwrite, retain) NSString *externalID;
@property (readwrite, retain) NSString *externalRevision;

// Relationships
@property (readonly, retain) NSMutableSet *attachments;
- (NSMutableSet *)attachments;

#pragma mark end emogenerator accessors

@end
