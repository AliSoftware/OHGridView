//
//  GridViewExampleAppDelegate.m
//  GridViewExample
//
//  Created by Olivier on 02/09/10.
//  Copyright AliSoftware 2010. All rights reserved.
//

#import "GridViewExampleAppDelegate.h"
#import "GridViewExampleViewController.h"

@implementation GridViewExampleAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
