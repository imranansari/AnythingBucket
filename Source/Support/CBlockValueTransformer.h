//
//  CBlockValueTransformer.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^TransformerBlock)(id);


@interface CBlockValueTransformer : NSValueTransformer

- (id)initWithBlock:(TransformerBlock)inBlock reverseBlock:(TransformerBlock)inReverseBlock;

@end
