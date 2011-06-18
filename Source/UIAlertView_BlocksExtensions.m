//
//  UIAlertView_BlocksExtensions.m
//  AnythingDB
//
//  Created by Jonathan Wight on 05/26/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "UIAlertView_BlocksExtensions.h"

#import <objc/runtime.h>

@interface AlertViewBlockDelegate : NSObject <UIAlertViewDelegate> {
}

@property (readwrite, nonatomic, copy) void (^handler)(UIAlertView *inAlertView, NSInteger buttonIndex);

@end

static const char kAssociationKey;

#pragma mark -

@implementation UIAlertView (UIAlertView_blocks)

- (id)initWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(NSInteger buttonIndex))inHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
    {
    if ((self = [self initWithTitle:title message:message delegate:NULL cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, NULL]) != NULL)
        {
        AlertViewBlockDelegate *theDelegate = [[AlertViewBlockDelegate alloc] init];
        theDelegate.handler = [inHandler copy];
        self.delegate = theDelegate;
        objc_setAssociatedObject(self, (void *)&kAssociationKey, theDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (otherButtonTitles)
            {
            va_list theArgs;
            va_start(theArgs, otherButtonTitles);
            id theArg = NULL;
            while ((theArg = va_arg(theArgs, id)) != NULL)
                {
                [self addButtonWithTitle:theArg];
                }
            va_end(theArgs);
            }
        }
    return(self);
    }

@end

#pragma mark -

@implementation AlertViewBlockDelegate

@synthesize handler;

- (void)alertView:(UIAlertView *)inAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
    {
    self.handler(inAlertView, buttonIndex);
    }

@end
