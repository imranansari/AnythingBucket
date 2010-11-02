//
//  CObjectTranscoder.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CObjectTranscoder : NSObject {

}

@property (readwrite, nonatomic, retain) NSSet *allowedKeys;

- (NSDictionary *)dictionaryForObject:(id)inObject error:(NSError **)outError;

@end

@protocol CObjectTranscoding 
@optional
+ (NSSet *)keysForEncodingAsType:(NSString *)inType;
+ (NSValueTransformer *)valueTransformerForTranscodingKey:(NSString *)inKey asType:(NSString *)inType;
+ (NSPredicate *)filterPredicateForTranscodingKey:(NSString *)inKey asType:(NSString *)inType;
@end