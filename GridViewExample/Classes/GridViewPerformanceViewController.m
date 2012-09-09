//
//  GridViewPerformanceViewController.m
//  GridViewExample
//
//  Created by Olivier Halligon on 09/09/12.
//
//

#import "GridViewPerformanceViewController.h"

@interface GridViewPerformanceViewController ()

@end

@implementation GridViewPerformanceViewController

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup & Teardown

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    OHGridView* grid = (OHGridView*)self.view;
    grid.columnsCount = 5;
    grid.rowHeight = 80;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OHGridView DataSource

#define kItemsCount 10000

-(NSUInteger)numberOfItemsInOHGridView:(OHGridView *)aGridView
{
    return kItemsCount;
}

-(OHGridViewCell *)OHGridView:(OHGridView *)aGridView cellAtIndexPath:(NSIndexPath *)indexPath
{
    OHGridViewCell* cell = [aGridView dequeueReusableCell];
    if (!cell)
    {
        cell = [OHGridViewCell cell];
    }
    CGFloat hue = fmodf([aGridView indexForIndexPath:indexPath] / 20.f , 1.0f);
    CGFloat lum = (([aGridView indexForIndexPath:indexPath] / 20) % 2 == 0) ? 0.5f : 1.f;
    cell.backgroundColor = [UIColor colorWithHue:hue saturation:0.5 brightness:lum alpha:1.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%d,%d", indexPath.row, indexPath.section];
    return cell;
}

@end
