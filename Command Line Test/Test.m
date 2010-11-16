#import <Foundation/Foundation.h>

#import "CObjectTranscoder.h"
#import <CoreLocation/CoreLocation.h>

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//
CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] init] autorelease];

id theObject = [[[CLLocation alloc] initWithLatitude:45 longitude:45] autorelease];

NSError *theError = NULL;
id theTranscodedObject = [theTranscoder transcodedObjectForObject:theObject error:&theError];
NSLog(@"Object: %@", theObject);
NSLog(@"Transcoded Object: %@", theTranscodedObject);
NSLog(@"Error: %@", theError);
//
[pool drain];
return 0;
}
