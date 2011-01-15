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
		cell = [[[OHGridViewCell alloc] initWithFrame:CGRectZero] autorelease];
		cell.backgroundColor = [UIColor grayColor];
	}
	
	NSUInteger i = indexPath.section + aGridView.columnsCount*indexPath.row;
	NSString* itemName = [items objectAtIndex:i];
	cell.textLabel.text = itemName;
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-64x64.png",itemName]];
	
	return cell;
}
-(void)gridView:(OHGridView *)aGridView didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger idx = indexPath.section + aGridView.columnsCount*indexPath.row;
	NSString* msg = [items objectAtIndex:idx];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Tap" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	((OHGridView*)self.view).columnsCount = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 2 : 4;
}

-(void)viewDidUnload {
	[items release];
	items = nil;
}

@end
