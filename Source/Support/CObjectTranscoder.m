//
//  CObjectTranscoder.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CObjectTranscoder.h"

#import <objc/runtime.h>

static const char* getPropertyType(objc_property_t property);

@interface CObjectTranscoder ()
- (id)transcodedObjectForMappingObject:(id)inObject error:(NSError **)outError;
- (id)transcodedObjectForArray:(NSArray *)inArray error:(NSError **)outError;
@end

#pragma mark -

@implementation CObjectTranscoder

@synthesize allowedKeys;

- (NSSet *)keysForEncodingObject:(id)inObject error:(NSError **)outError
    {
    if ([[inObject class] respondsToSelector:@selector(keysForEncodingAsType:)])
        {
        return([[inObject class] keysForEncodingAsType:NULL]);
        }
    else
        {
        NSMutableSet *theKeys = [NSMutableSet set];
        unsigned int thePropertyCount = 0;
        objc_property_t *theProperties = class_copyPropertyList([inObject class], &thePropertyCount);
        for (unsigned int N = 0; N != thePropertyCount; ++N)
            {
            NSString *thePropertyName = [NSString stringWithUTF8String:property_getName(theProperties[N])];
            [theKeys addObject:thePropertyName];
            }
        free(theProperties);
        return(theKeys);
        }
    }

- (id)transcodedObjectForObject:(id)inObject error:(NSError **)outError
	{
	if ([inObject isKindOfClass:[NSString class]])
		{
		return(inObject);
		}
	else if ([inObject isKindOfClass:[NSURL class]])
		{
		return(inObject);
		}
	else if ([inObject isKindOfClass:[NSNumber class]])
		{
		return(inObject);
		}
	else if ([inObject isKindOfClass:[NSDate class]])
		{
		return(inObject);
		}
	else if ([inObject isKindOfClass:[NSData class]])
		{
		return(inObject);
		}
	else if (inObject == [NSNull null])
		{
		return(NULL);
		}
	else if ([inObject isKindOfClass:[NSArray class]])
		{
		return([self transcodedObjectForArray:inObject error:outError]);
		}
	else if ([inObject isKindOfClass:[NSSet class]])
		{
		return([self transcodedObjectForArray:[inObject allObjects] error:outError]);
		}
	else if ([inObject isKindOfClass:[NSDictionary class]])
		{
		return([self transcodedObjectForMappingObject:inObject error:outError]);
		}
	else
		{
		return([self transcodedObjectForMappingObject:inObject error:outError]);
		}
	}

- (id)transcodedObjectForMappingObject:(id)inObject error:(NSError **)outError
    {
    NSMutableDictionary *theDictionary = [NSMutableDictionary dictionary];
    
    NSMutableSet *theKeys = [[self keysForEncodingObject:inObject error:outError] mutableCopy];
    if (self.allowedKeys)
        {
        [theKeys intersectSet:self.allowedKeys];
        }
    
    for (NSString *theKey in theKeys)
        {
		id theValue = NULL;
		@try
			{
			theValue = [inObject valueForKey:theKey];
			}
		@catch (NSException * e)
			{
			NSLog(@"%@", e);
			continue;
			}
		
        id theTranscodedValue = NULL;

        if ([[inObject class] respondsToSelector:@selector(filterPredicateForTranscodingKey:asType:)])
            {
            NSPredicate *thePredicate = [[inObject class] filterPredicateForTranscodingKey:theKey asType:NULL];
            if (thePredicate)
                {
                if ([thePredicate evaluateWithObject:inObject] == NO)
                    continue;
                }
            }
        
        if ([[inObject class] respondsToSelector:@selector(valueTransformerForTranscodingKey:asType:)])
            {
            NSValueTransformer *theValueTransformer = [[inObject class] valueTransformerForTranscodingKey:theKey asType:NULL];
            if (theValueTransformer)
                {
                theTranscodedValue = [theValueTransformer transformedValue:theValue];
                }
            }
            
        if (theTranscodedValue == NULL)
            {
			// TODO make null optionsal.
            theTranscodedValue = [self transcodedObjectForObject:theValue error:outError];
            }

        [theDictionary setValue:theTranscodedValue forKey:theKey];
        }
    
    return(theDictionary);
    }
    
#pragma mark -

- (id)transcodedObjectForArray:(NSArray *)inArray error:(NSError **)outError
	{
	NSMutableArray *theTranscodedArray = [NSMutableArray arrayWithCapacity:[inArray count]];
	for (id theValue in inArray)
		{
		NSError *theError = NULL;
		id theTranscodedValue = [self transcodedObjectForObject:theValue error:&theError];
		[theTranscodedArray addObject:theTranscodedValue];
		}
	
	return(theTranscodedArray);
	}

- (NSDictionary *)transcodedObjectForDictionary:(NSDictionary *)inDictionary error:(NSError **)outError
	{
	return(NULL);
	}

@end

static const char* getPropertyType(objc_property_t property) {
    // parse the property attribues. this is a comma delimited string. the type of the attribute starts with the
    // character 'T' should really just use strsep for this, using a C99 variable sized array.
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            // return a pointer scoped to the autorelease pool. Under GC, this will be a separate block.
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute)] bytes];
        }
    }
    return "@";
}
