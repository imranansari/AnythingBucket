//
//  CPosting_TranscoderExtensions.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPosting_TranscoderExtensions.h"


@implementation CPosting (CPosting_TranscoderExtensions)

+ (NSSet *)keysForEncodingAsType:(NSString *)inType
    {
    return([NSSet setWithObjects:@"title", @"body", @"location", @"tags", @"created", NULL]);
    }

@end
