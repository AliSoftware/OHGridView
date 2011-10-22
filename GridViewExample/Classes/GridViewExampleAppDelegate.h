//
//  GridViewExampleAppDelegate.h
//  GridViewExample
//
//  Created by Olivier on 02/09/10.
//  Copyright AliSoftware 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridViewExampleViewController;

@interface GridViewExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GridViewExampleViewController *viewController;
}

@property (nonatomic, arc_strong) IBOutlet UIWindow *window;
@property (nonatomic, arc_strong) IBOutlet GridViewExampleViewController *viewController;

@end

