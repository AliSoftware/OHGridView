//
//  GridViewExampleViewController.m
//  GridViewExample
//
//  Created by Olivier on 02/09/10.
//  Copyright AliSoftware 2010. All rights reserved.
//

#import "GridViewExampleViewController.h"

@implementation GridViewExampleViewController

-(void)viewDidLoad {
	// Images are courtesy of http://www.iconspedia.com/pack/iphone/
	items = [[NSArray alloc] initWithObjects:
			 @"browser",@"calc",@"chat-blank",@"clock",@"graph",@"ipod",
			 @"mail",@"map",@"notes",@"photo",@"tools",@"wallpaper",@"weather",
			 nil];

	((OHGridView*)self.view).rowHeight = 100;
	((OHGridView*)self.view).columnsCount = 2;
}

-(NSUInteger)numberOfItemsInGridView:(OHGridView *)aGridView {
	return [items count];
}
-(OHGridViewCell*)gridView:(OHGridView *)aGridView cellAtIndexPath:(NSIndexPath *)indexPath {
	OHGridViewCell* cell = [aGridView dequeueReusableCell];
	if (!cell) {
		cell = [OHGridViewCell cell];
		
		// First simple way to set a backgrounf
		//cell.backgroundColor = [UIColor grayColor]; // One way
		
		// Another way, using custom view (so you may also user an UIImageView or whatever you need
		cell.backgroundView = noarc_autorelease([[UIView alloc] initWithFrame:CGRectZero]);
		cell.backgroundView.backgroundColor = [UIColor colorWithRed:0.5f green:0.8f blue:0.5f alpha:1.f];

		cell.selectedBackgroundView = noarc_autorelease([[UIView alloc] initWithFrame:CGRectZero]);
		cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.8f alpha:1.f];
	}
	
	NSUInteger i = [aGridView indexForIndexPath:indexPath];
	NSString* itemName = [items objectAtIndex:i];
	cell.textLabel.text = itemName;
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-64x64.png",itemName]];
	
	return cell;
}
-(void)gridView:(OHGridView *)aGridView didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger idx = [aGridView indexForIndexPath:indexPath];
	NSString* msg = [items objectAtIndex:idx];
	UIAlertView* alert = noarc_autorelease([[UIAlertView alloc] initWithTitle:@"Tap"
                                                                      message:msg
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil]);
	[alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[(OHGridView*)self.view deselectSelectedCellsAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	((OHGridView*)self.view).columnsCount = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 2 : 4;
}

-(void)viewDidUnload {
	noarc_release(items);
	items = nil;
}

@end
