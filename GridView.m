//
//  GridView.m
//  Clementine
//
//  Created by Olivier on 02/09/10.
//  Copyright 2010 AliSoftware. All rights reserved.
//

#import "GridView.h"

/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: GridViewCell
/////////////////////////////////////////////////////////////////////////////

@interface GridViewCell()
@property(nonatomic,retain) NSIndexPath* indexPath;
@end

@implementation GridViewCell
@synthesize indexPath;
@synthesize imageView, textLabel;

/////////////////////////////////////////////////////////////////////////////
// MARK: Init/Dealloc

-(void)configure
{
	imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:imageView];
	
	textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	textLabel.textAlignment = UITextAlignmentCenter;
	textLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:textLabel];
}

-(id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]) != nil) {
		[self configure];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder]) != nil) {
		[self configure];
	}
	return self;
}

-(void)dealloc {
	[indexPath release];
	[imageView release];
	[textLabel release];
	[super dealloc];
}

/////////////////////////////////////////////////////////////////////////////
// MARK: Tiling & Touch Mgmt

-(void)layoutSubviews {
	const CGFloat kLabelHeight = 21;
	CGRect r = CGRectInset(self.bounds,5,5);
	r.size.height -= kLabelHeight;
	imageView.frame = r;
	
	r = CGRectInset(self.bounds,5,5);
	r.size.height = kLabelHeight;
	r.origin.y = CGRectGetMaxY(imageView.frame);
	textLabel.frame = r;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	GridView* gridView = (GridView*)self.superview;
	if ([gridView.delegate respondsToSelector:@selector(gridView:didSelectCellAtIndexPath:)])
		[gridView.delegate gridView:gridView didSelectCellAtIndexPath:self.indexPath];
}

@end





/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: GridView
/////////////////////////////////////////////////////////////////////////////

@implementation GridView
@synthesize delegate, dataSource;
@synthesize columnsCount, rowHeight, marginWidth;

/////////////////////////////////////////////////////////////////////////////
// MARK: Init/Dealloc

-(void)configure {
	visibleCells = [[NSMutableSet alloc] init];
	recyclePool = [[NSMutableSet alloc] init];
	columnsCount = 3;
	rowHeight = 200.f;
	marginWidth = 0.5f;
	self.clipsToBounds = YES;
}
- (id) initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self configure];
	}
	return self;
}

- (id) initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self != nil) {
		[self configure];
	}
	return self;
}

-(void)dealloc {
	[visibleCells release];
	[recyclePool release];
	[super dealloc];
}

-(void)willMoveToWindow:(UIWindow *)newWindow {
	if (newWindow) [self reloadData];
}

/////////////////////////////////////////////////////////////////////////////
// MARK: Loading & Tiling cells

-(void)reloadData {
	itemsCount = [self.dataSource numberOfItemsInGridView:self];
	NSUInteger nbRows = (itemsCount>0) ? ((itemsCount-1) / columnsCount)+1 : 0;
	self.contentSize = CGSizeMake(self.bounds.size.width, self.rowHeight*nbRows);
	// remove all cells
	for(UIView* v in visibleCells) {
		[recyclePool addObject:v];
		[v removeFromSuperview];
	}
	[visibleCells removeAllObjects];
	// relayout and reload cells
	[self setNeedsLayout];
}

-(void)setColumnsCount:(NSUInteger)val {
	[self willChangeValueForKey:@"columnsCount"];
	columnsCount = val;
	[self didChangeValueForKey:@"columnsCount"];
	// as previous index paths for some columns may not be accessible anymore, we need to recreate it all
	[self reloadData]; // this will relayout and recompute the contentSize too
}

-(void)setRowHeight:(CGFloat)val {
	[self willChangeValueForKey:@"rowHeight"];
	rowHeight = val;
	[self setNeedsLayout]; // no need to reload all data, only relayout.
	[self didChangeValueForKey:@"rowHeight"];
}

/////////////////////////////////////////////////////////////////////////////

-(GridViewCell*)dequeueReusableCell {
	id obj = [recyclePool anyObject];
	if (obj) {
		[[obj retain] autorelease];
		[recyclePool removeObject:obj];
	}
	return obj;
}

-(GridViewCell*)visibleCellForIndexPath:(NSIndexPath*)indexPath {
	for(GridViewCell* cell in visibleCells) {
		if (cell.indexPath == indexPath) {
			return cell;
		}
	}
	return nil;
}

-(void)layoutSubviews
{	
	// remove cells that are no longer visible
	for(UIView* v in visibleCells) {
		if (!CGRectIntersectsRect(v.frame, self.bounds)) {
			[recyclePool addObject:v];
			[v removeFromSuperview];
		}
	}
	[visibleCells minusSet:recyclePool];
	
	if (itemsCount==0) return;
	
	// tile missing cells
	NSUInteger firstRow = floorf( CGRectGetMinY(self.bounds) / rowHeight );
	firstRow = MAX(firstRow,0);
	NSUInteger lastRow = floorf( (CGRectGetMaxY(self.bounds)-1) / rowHeight ) + 1;
	NSUInteger totalNumRows = (itemsCount>0) ? ((itemsCount-1) / columnsCount)+1 : 0;
	lastRow = MIN(lastRow, totalNumRows);
	CGFloat w = self.bounds.size.width / columnsCount;
	for(int row = firstRow; row<lastRow; ++row) {
		for (NSUInteger col= 0; col < self.columnsCount; ++col) {
			if (row*columnsCount+col>=itemsCount) return;
			NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:col];
			GridViewCell* cell = [self visibleCellForIndexPath:path];
			if (!cell) {
				cell = [self.dataSource gridView:self cellAtIndexPath:path];
				cell.indexPath = path;
				[visibleCells addObject:cell];
				[self addSubview:cell];
			}
			cell.frame = CGRectInset( CGRectMake(col*w,row*rowHeight,w,rowHeight) , marginWidth,marginWidth);
			if ([self.delegate respondsToSelector:@selector(gridView:willDisplayCell:forIndexPath:)])
				[self.delegate gridView:self willDisplayCell:cell forIndexPath:path];
		}
	}
}

@end
