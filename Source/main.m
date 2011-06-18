//
//  main.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMainWindowController.h"

int main(int argc, char *argv[])
    {
    @autoreleasepool
        {
        int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([CMainWindowController class]));
        return retVal;
        }
    }

