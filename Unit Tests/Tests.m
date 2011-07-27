//
//  Tests.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 11/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "Tests.h"

@interface CBlockTestCase : SenTest
@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic, copy) void (^block)(void);
@property (readwrite, nonatomic, retain) SenTestRun *currentRun;
@end

#pragma mark -

@implementation Tests

+ (void)load
    {
    }

- (id)initWithName:(NSString *) aName;
	{
	if ((self = [super initWithName:aName]) != NULL)
		{
        unsigned int theClassCount = 0;
        Class *theClassList = objc_copyClassList(&theClassCount);
        for (unsigned int i = 0; i != theClassCount; ++i)
            {
            Class theClass = theClassList[i];
            unsigned int theMethodCount = 0;
            Method *theMethodList = class_copyMethodList(object_getClass(theClass), &theMethodCount);
            for (unsigned int j = 0; j != theMethodCount; ++j)
                {
                SEL theSelector = method_getName(theMethodList[j]);
                if ([NSStringFromSelector(theSelector) rangeOfString:@"test_"].location == 0)
                    {
                    NSLog(@"**** ADDING INLINE TEST FOR: %@ %@", theClass, NSStringFromSelector(theSelector));

                    CBlockTestCase *theTestCase = [[CBlockTestCase alloc] init];
                    theTestCase.name = [NSString stringWithFormat:@"+[%@ %@]", NSStringFromClass(theClass), NSStringFromSelector(theSelector)];
                    theTestCase.block = ^(void) { [theClass performSelector:theSelector]; };

                    objc_setAssociatedObject(theClass, "xyzzy", theTestCase, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

                    [self addTest:theTestCase];
                    }
                }
            }
		}
	return(self);
	}

@end

#pragma mark -

@implementation CBlockTestCase

@synthesize name;
@synthesize block;
@synthesize currentRun;

- (Class)testRunClass
    {
    return([SenTestCaseRun class]);
    }

- (void)performTest:(SenTestRun *) aRun
    {
    self.currentRun = aRun;
    [aRun start];
    block();
    [aRun stop];
    }

- (void)failWithException:(NSException *)inException
    {
    [(SenTestCaseRun *)self.currentRun addException:inException];
    }

@end

#pragma mark -

#pragma mark -

@implementation NSObject (NSObject_Tests)

+ (void)failWithException:(NSException *) anException;
    {
    CBlockTestCase *theTestCase = objc_getAssociatedObject(self, "xyzzy");
    [theTestCase failWithException:anException];
    }

@end
