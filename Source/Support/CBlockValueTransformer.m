//
//  CBlockValueTransformer.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CBlockValueTransformer.h"

@interface CBlockValueTransformer ()
@property (readonly, nonatomic, retain) TransformerBlock block;
@property (readonly, nonatomic, retain) TransformerBlock reverseBlock;
@end

#pragma mark -

@implementation CBlockValueTransformer

@synthesize block;
@synthesize reverseBlock;

+ (BOOL)allowsReverseTransformation
    {
    return(YES);
    }

- (id)initWithBlock:(TransformerBlock)inBlock reverseBlock:(TransformerBlock)inReverseBlock
    {
    if ((self = [super init]) != NULL)
        {
        block = inBlock;
        reverseBlock = inReverseBlock;
        }
    return(self);
    }

- (void)dealloc
    {
    block = NULL;
    reverseBlock = NULL;
    //
    }

- (id)transformedValue:(id)value
    {
    if (self.block)
        {
        return(self.block(value));
        }
    else
        {
        return(NULL);
        }
    }

- (id)reverseTransformedValue:(id)value
    {
    if (self.reverseBlock)
        {
        return(self.reverseBlock(value));
        }
    else
        {
        return(NULL);
        }
    }

@end
