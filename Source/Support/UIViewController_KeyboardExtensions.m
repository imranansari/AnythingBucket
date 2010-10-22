//
//  UIViewController_KeyboardExtension.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "UIViewController_KeyboardExtensions.h"

#import <objc/runtime.h>

@implementation UIViewController (UIViewController_KeyboardExtensions)

- (void)respondToKeyboardAppearance
    {
    id theObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:self.view.window queue:NULL usingBlock:^(NSNotification *arg1) {

        CGRect theKeyboardFrame = [[arg1.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval theDuration = [[arg1.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve theCurve = [[arg1.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

        CGRect theFrame = self.view.frame;
        
//        NSLog(@"%@", NSStringFromCGRect(theFrame));
        
        objc_setAssociatedObject(self, "foo", [NSValue valueWithCGRect:theFrame], OBJC_ASSOCIATION_RETAIN);
        
        theFrame = [self.view convertRect:theFrame toView:self.view.window];
        
        CGFloat theY = MIN(theFrame.size.height, CGRectGetMinY(theKeyboardFrame));

        theFrame.size.height = theY - theFrame.origin.y;
        
        theFrame = [self.view convertRect:theFrame fromView:self.view.window];
        
        [UIView animateWithDuration:theDuration delay:0.0 options:theCurve << 16 animations:^(void) { self.view.frame = theFrame; } completion:NULL];
        }];
    objc_setAssociatedObject(self, "kb-show-observer", theObserver, OBJC_ASSOCIATION_RETAIN);

    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:self.view.window queue:NULL usingBlock:^(NSNotification *arg1) {
        NSTimeInterval theDuration = [[arg1.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve theCurve = [[arg1.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

        CGRect theFrame = [objc_getAssociatedObject(self, "foo") CGRectValue];
        
        [UIView animateWithDuration:theDuration delay:0.0 options:theCurve << 16 animations:^(void) { self.view.frame = theFrame; } completion:NULL];
        }];
    objc_setAssociatedObject(self, "kb-hide-observer", theObserver, OBJC_ASSOCIATION_RETAIN);
    }

- (void)stopRespondingToKeyboardAppearance
    {
    [[NSNotificationCenter defaultCenter] removeObserver:objc_getAssociatedObject(self, "kb-show-observer")];
    [[NSNotificationCenter defaultCenter] removeObserver:objc_getAssociatedObject(self, "kb-hide-observer")];
    }


@end
