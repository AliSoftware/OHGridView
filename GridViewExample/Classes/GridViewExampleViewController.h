//
//  GridViewExampleViewController.h
//  GridViewExample
//
//  Created by Olivier on 02/09/10.
//  Copyright AliSoftware 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHGridView/OHGridView.h>

@interface GridViewExampleViewController : UIViewController
    <UIAlertViewDelegate, OHGridViewDelegate, OHGridViewDataSource> {
	NSArray* items;
}
@end

