//
//  UIAlertView_BlocksExtensions.h
//  AnythingDB
//
//  Created by Jonathan Wight on 05/26/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (UIAlertView_BlocksExtensions)

- (id)initWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(UIAlertView *inAlertView, NSInteger buttonIndex))inHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
