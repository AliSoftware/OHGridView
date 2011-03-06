//
//  OHGridView.m
//
//  Created by Olivier on 02/09/10.
//  Copyright 2010 AliSoftware. All rights reserved.
//

#import "OHGridView.h"

/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: OHGridViewCell
/////////////////////////////////////////////////////////////////////////////

@interface OHGridViewCell()
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign) BOOL selected;
@end

@implementation OHGridViewCell
@synthesize indexPath;
@synthesize imageView, textLabel;
@synthesize selected;
@synthesize backgroundView, selectedBackgroundView;

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

+(OHGridViewCell*)cell {
	return [[[self alloc] initWithFrame:CGRectZero] autorelease];
}

-(void)dealloc {
	[indexPath release];
	[imageView release];
	[textLabel release];
	[backgroundView release];
	[selectedBackgroundView release];
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
	
	backgroundView.frame = self.bounds;
	selectedBackgroundView.frame = self.bounds;
}

-(void)setSelected:(BOOL)sel {
	if (sel && selectedBackgroundView) {
		[backgroundView removeFromSuperview];
		[self insertSubview:selectedBackgroundView atIndex:0];
	} else {
		[selectedBackgroundView removeFromSuperview];
		[self insertSubview:backgroundView atIndex:0];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	OHGridView* gridView = (OHGridView*)self.superview;
	gridView.indexPathForSelectedCell = self.indexPath;

	if ([gridView.delegate respondsToSelector:@selector(gridView:willSelectCellAtIndexPath:)])
		[gridView.delegate gridView:gridView willSelectCellAtIndexPath:self.indexPath];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	OHGridView* gridView = (OHGridView*)self.superview;
	gridView.indexPathForSelectedCell = self.indexPath;
	
	if ([gridView.delegate respondsToSelector:@selector(gridView:didSelectCellAtIndexPath:)])
		[gridView.delegate gridView:gridView didSelectCellAtIndexPath:self.indexPath];
}

-(void)setBackgroundView:(UIView*)view {
	if (view != backgroundView) {
		if ([backgroundView superview]==self) {
			[backgroundView removeFromSuperview];
		}
		[backgroundView release];
		backgroundView = [view retain];
		
		backgroundView.frame = self.bounds;
		backgroundView.userInteractionEnabled = NO;
		
		if ([selectedBackgroundView superview]!=self) {
			// If we don't have selectedBackgroundView or we have one but not currently displayed (= cell not selected)
			[self insertSubview:view atIndex:0];
		}
	}
}

-(void)setSelectedBackgroundView:(UIView*)view {
	if (view != selectedBackgroundView) {
		if ([selectedBackgroundView superview]==self) {
			[selectedBackgroundView removeFromSuperview];
		}
		[selectedBackgroundView release];
		selectedBackgroundView = [view retain];
		
		selectedBackgroundView.frame = self.bounds;
		selectedBackgroundView.userInteractionEnabled = NO;
		
		if (backgroundView && [backgroundView superview]!=self) {
			// If we have a backgroundView but it is not currently displayed (= cell selected)
			[self insertSubview:view atIndex:0];
		}
	}
}

@end











/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: OHGridView
/////////////////////////////////////////////////////////////////////////////
@interface OHGridView(/* Private */)
-(void)configure;
-(OHGridViewCell*)visibleCellForIndexPath:(NSIndexPath*)indexPath;
@end


@implementation OHGridView
@synthesize delegate, dataSource;
@synthesize columnsCount, rowHeight, marginWidth;
@synthesize indexPathForSelectedCell;

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
	NSInteger selectedIdx = (indexPathForSelectedCell.section + indexPathForSelectedCell.row*columnsCount);
	columnsCount = val;
	indexPathForSelectedCell = [NSIndexPath indexPathForRow:(selectedIdx/val) inSection:(selectedIdx%val)];
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

-(void)setMarginWidth:(CGFloat)val {
	[self willChangeValueForKey:@"marginWidth"];
	marginWidth = val;
	[self setNeedsLayout]; // no need to reload all data, only relayout.
	[self didChangeValueForKey:@"marginWidth"];	
}

-(void)setIndexPathForSelectedCell:(NSIndexPath *)indexPath {
	if (indexPath != indexPathForSelectedCell) {
		[self willChangeValueForKey:@"indexPathForSelectedCell"];
		[self visibleCellForIndexPath:indexPathForSelectedCell].selected = NO;
		[indexPathForSelectedCell release];
		indexPathForSelectedCell = [indexPath retain];
		[self visibleCellForIndexPath:indexPathForSelectedCell].selected = YES;
		[self didChangeValueForKey:@"indexPathForSelectedCell"];
	}
}

/////////////////////////////////////////////////////////////////////////////

-(OHGridViewCell*)dequeueReusableCell {
	OHGridViewCell* cell = [recyclePool anyObject];
	if (cell) {
		[[cell retain] autorelease];
		[recyclePool removeObject:cell];
	}
	if ([cell.selectedBackgroundView superview]==cell) {
		[cell.selectedBackgroundView removeFromSuperview];
		[cell insertSubview:cell.backgroundView atIndex:0];
	}
	cell.backgroundView.frame = cell.bounds;
	cell.selectedBackgroundView.frame = cell.bounds;
	cell.selected = NO;
	return cell;
}

-(OHGridViewCell*)visibleCellForIndexPath:(NSIndexPath*)indexPath {
	for(OHGridViewCell* cell in visibleCells) {
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
			OHGridViewCell* cell = [self visibleCellForIndexPath:path];
			if (!cell) {
				cell = [self.dataSource gridView:self cellAtIndexPath:path];
				cell.indexPath = path;
				cell.selected = (path == self.indexPathForSelectedCell);
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
