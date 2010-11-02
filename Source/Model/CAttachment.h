//
//  CAttachment.h
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 10/22/10
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#pragma mark begin emogenerator forward declarations
@class CPosting;
#pragma mark end emogenerator forward declarations

/** Attachment */
@interface CAttachment : NSManagedObject {
}

#pragma mark begin emogenerator accessors

+ (NSString *)entityName;

// Attributes
@property (readwrite, retain) NSData *data;
@property (readwrite, retain) NSString *contentType;
@property (readwrite, retain) NSString *identifier;

// Relationships
@property (readwrite, retain) CPosting *posting;
- (CPosting *)posting;
- (void)setPosting:(CPosting *)inPosting;

#pragma mark end emogenerator accessors

@end
