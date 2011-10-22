//
//  main.m
//  GridViewExample
//
//  Created by Olivier on 02/09/10.
//  Copyright AliSoftware 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
#if 1
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, nil);
    }
#else
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
#endif
}
