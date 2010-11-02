//
//  CBumpManager.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 11/01/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBumpManager : NSObject {
}

+ (CBumpManager *)sharedInstance;

- (void)bump:(id)inParameter;

@end
