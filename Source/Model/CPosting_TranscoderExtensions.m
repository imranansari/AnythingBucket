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
//    return([NSSet setWithObjects:@"title", NULL]);
    return([NSSet setWithObjects:@"title", @"body", @"location", @"tags", NULL]);
    }

//+ (NSValueTransformer *)valueTransformerForTranscodingKey:(NSString *)inKey asType:(NSString *)inType
//    {
//    if ([inKey isEqualToString:@"coordinate"])
//        {
//        TransformerBlock theBlock = ^(id inValue) {
//            CLLocationCoordinate2D theCoordinate;
//            [inValue getValue:&theCoordinate];
//            return([NSDictionary dictionaryWithObjectsAndKeys:
//                [NSNumber numberWithDouble:theCoordinate.latitude], @"latitude",
//                [NSNumber numberWithDouble:theCoordinate.longitude], @"longitude",
//                NULL]);
//            };
//        NSValueTransformer *theValueTransformer = [[[CBlockValueTransformer alloc] initWithBlock:theBlock reverseBlock:NULL] autorelease];
//        return(theValueTransformer);
//        }
//    else
//        {
//        return(NULL);
//        }
//    }
//
//+ (NSPredicate *)filterPredicateForTranscodingKey:(NSString *)inKey asType:(NSString *)inType
//    {
//    if ([inKey isEqualToString:@"course"])
//        {
//        id theBlock = ^(CLLocation *evaluatedObject, NSDictionary *bindings) { return(evaluatedObject.course >= 0.0); };
//        
//        NSPredicate *thePredicate = [NSPredicate predicateWithBlock:theBlock];
//        return(thePredicate);
//        }
//    else
//        {
//        return(NULL);
//        }
//
//    }

@end
