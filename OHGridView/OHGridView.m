/***********************************************************************************
 * The OHGridView library is under the MIT License quoted below:
 ***********************************************************************************
 *
 * Copyright (c) 2010 Olivier Halligon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ***********************************************************************************/

#import "OHGridView.h"

/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHGridViewCell

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Private OHGridViewCell Interface

@interface OHGridViewCell()
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign) BOOL selected;
-(void)setSelected:(BOOL)sel animated:(BOOL)animated;
@end

/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHGridViewCell Implementation

@implementation OHGridViewCell
// Public Properties Synthesis
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize backgroundView = _backgroundView;
@synthesize selectedBackgroundView = _selectedBackgroundView;
// Private Properties Synthesis
@synthesize indexPath = _indexPath;
@synthesize selected = _selected;

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Init/Dealloc

-(void)configure
{
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:_imageView];
	
	_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_textLabel.textAlignment = UITextAlignmentCenter;
	_textLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:_textLabel];
}

-(id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
    {
		[self configure];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil)
    {
		[self configure];
	}
	return self;
}

+(OHGridViewCell*)cell
{
	OHGridViewCell* newCell = [[self alloc] initWithFrame:CGRectZero];
#if ! __has_feature(objc_arc)
    [newCell autorelease]
#endif
    return newCell;
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    // Public properties
	[_imageView release];
	[_textLabel release];
	[_backgroundView release];
	[_selectedBackgroundView release];
    // Private properties
	[_indexPath release];
	[super dealloc];
}
#endif


/////////////////////////////////////////////////////////////////////////////
#pragma mark - Tiling & Touch Mgmt

-(void)layoutSubviews
{
	CGFloat labelHeight = self.textLabel.font.lineHeight;
    
	CGRect r = CGRectInset(self.bounds,5,5);
    if (self.textLabel.text)
    {
        r.size.height -= labelHeight;
    }
	self.imageView.frame = r;
	
	r = CGRectInset(self.bounds,5,5);
    if (self.imageView.image)
    {
        r.size.height = labelHeight;
        r.origin.y = CGRectGetMaxY(self.imageView.frame);
    }
	self.textLabel.frame = r;
	
	self.backgroundView.frame = self.bounds;
	self.selectedBackgroundView.frame = self.bounds;
    
    [super layoutSubviews];
}

-(void)setSelected:(BOOL)sel
{
	[self setSelected:sel animated:NO];
}

-(void)setSelected:(BOOL)sel animated:(BOOL)animated
{
    dispatch_block_t changeSelection = ^(void)
    {
        if (sel && self.selectedBackgroundView)
        {
            self.backgroundView.alpha = 0.f;
            self.selectedBackgroundView.alpha = 1.f;
        }
        else
        {
            self.selectedBackgroundView.alpha = 0.f;
            self.backgroundView.alpha = 1.f;
        }
    };
    
    if (animated)
    {
        static const NSTimeInterval duration = 0.5f;
        [UIView transitionWithView:self
                          duration:duration
                           options:UIViewAnimationOptionShowHideTransitionViews
                        animations:changeSelection
                        completion:nil];
    }
    else
    {
        changeSelection();
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	OHGridView* gridView = (OHGridView*)self.superview;
	gridView.indexPathForSelectedCell = self.indexPath;

	if ([gridView.gridViewDelegate respondsToSelector:@selector(OHGridView:willSelectCellAtIndexPath:)])
    {
		[gridView.gridViewDelegate OHGridView:gridView willSelectCellAtIndexPath:self.indexPath];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	OHGridView* gridView = (OHGridView*)self.superview;
	gridView.indexPathForSelectedCell = self.indexPath;
	
	if ([gridView.gridViewDelegate respondsToSelector:@selector(OHGridView:didSelectCellAtIndexPath:)])
    {
		[gridView.gridViewDelegate OHGridView:gridView didSelectCellAtIndexPath:self.indexPath];
    }
}

-(void)setBackgroundView:(UIView*)view
{
	if (view != _backgroundView)
    {
		if ([_backgroundView superview] == self)
        {
			[_backgroundView removeFromSuperview];
		}
#if ! __has_feature(objc_arc)
		[_backgroundView release];
		_backgroundView = [view retain];
#else
        _backgroundView = view;
#endif
		
		_backgroundView.frame = self.bounds;
		_backgroundView.userInteractionEnabled = NO;
		[self setSelected:self.selected animated:NO]; // update
		
		[self insertSubview:view atIndex:0];
	}
}

-(void)setSelectedBackgroundView:(UIView*)view
{
	if (view != _selectedBackgroundView)
    {
		if ([_selectedBackgroundView superview] == self)
        {
			[_selectedBackgroundView removeFromSuperview];
		}
#if ! __has_feature(objc_arc)
		[_selectedBackgroundView release];
		_selectedBackgroundView = [view retain];
#else
        _selectedBackgroundView = view;
#endif
		
		_selectedBackgroundView.frame = self.bounds;
		_selectedBackgroundView.userInteractionEnabled = NO;
		[self setSelected:self.selected animated:NO]; // update
		
		[self insertSubview:view atIndex:_backgroundView?1:0];
	}
}

@end











/////////////////////////////////////////////////////////////////////////////
#pragma mark - Private OHGridView Interface

@interface OHGridView(/* Private */)
-(void)configure;
-(OHGridViewCell*)visibleCellForIndexPath:(NSIndexPath*)indexPath;
@property(nonatomic, assign) NSUInteger itemsCount;
@property(nonatomic, retain) NSMutableSet* visibleCells;
@property(nonatomic, retain) NSMutableSet* recyclePool;
@end


/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHGridView Implementation

@implementation OHGridView
// Public Properties Synthesis
@synthesize indexPathForSelectedCell = _indexPathForSelectedCell;
@synthesize gridViewDelegate = _gridViewDelegate;
@synthesize gridViewDataSource = _gridViewDataSource;
@synthesize columnsCount = _columnsCount;
@synthesize rowHeight = _rowHeight;
@synthesize marginWidth = _marginWidth;
// Private Properties Synthesis
@synthesize itemsCount = _itemsCount;
@synthesize visibleCells = _visibleCells;
@synthesize recyclePool = _recyclePool;

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Init/Dealloc

-(void)configure
{
	_visibleCells = [[NSMutableSet alloc] init];
	_recyclePool = [[NSMutableSet alloc] init];
	_columnsCount = 3;
	_rowHeight = 200.f;
	_marginWidth = 1.0f;
	self.clipsToBounds = YES;
}
- (id) initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil)
    {
		[self configure];
	}
	return self;
}

- (id) initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self != nil)
    {
		[self configure];
	}
	return self;
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    // Public properties
    [_indexPathForSelectedCell release];
    // Private properties
	[_visibleCells release];
	[_recyclePool release];
	[super dealloc];
}
#endif

-(void)willMoveToWindow:(UIWindow *)newWindow
{
	if (newWindow) [self reloadData];
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Loading & Tiling cells

-(void)reloadData
{
	self.itemsCount = [self.gridViewDataSource numberOfItemsInOHGridView:self];
	NSUInteger nbRows = (self.itemsCount>0) ? ((self.itemsCount-1) / self.columnsCount)+1 : 0;
	self.contentSize = CGSizeMake(self.bounds.size.width, self.rowHeight*nbRows);
	// remove all cells
	for(UIView* v in self.visibleCells)
    {
		[self.recyclePool addObject:v];
		[v removeFromSuperview];
	}
	[self.visibleCells removeAllObjects];
	// relayout and reload cells
	[self setNeedsLayout];
}

-(NSInteger)indexForIndexPath:(NSIndexPath*)indexPath
{
	return indexPath ? (indexPath.section + indexPath.row * self.columnsCount) : -1;
}

-(void)setColumnsCount:(NSUInteger)val
{
	NSInteger selectedIdx = [self indexForIndexPath:self.indexPathForSelectedCell];
	_columnsCount = val;
	self.indexPathForSelectedCell = (selectedIdx<0) ? nil : [NSIndexPath indexPathForRow:(selectedIdx/val) inSection:(selectedIdx%val)];
	
	// as previous index paths for some columns may not be accessible anymore, we need to recreate it all
	[self reloadData]; // this will relayout and recompute the contentSize too
}

-(void)setRowHeight:(CGFloat)val
{
	_rowHeight = val;
	[self setNeedsLayout]; // no need to reload all data, only relayout.
}

-(void)setMarginWidth:(CGFloat)val
{
	_marginWidth = val;
	[self setNeedsLayout]; // no need to reload all data, only relayout.
}

-(void)deselectSelectedCellsAnimated:(BOOL)animated
{
	[self setIndexPathForSelectedCell:nil animated:animated];
}

-(void)setIndexPathForSelectedCell:(NSIndexPath *)indexPath
{
	[self setIndexPathForSelectedCell:indexPath animated:YES];
}

-(void)setIndexPathForSelectedCell:(NSIndexPath *)indexPath animated:(BOOL)animated
{
	if (indexPath != _indexPathForSelectedCell)
    {
		[[self visibleCellForIndexPath:_indexPathForSelectedCell] setSelected:NO animated:animated];
#if ! __has_feature(objc_arc)
		[_indexPathForSelectedCell release];
		_indexPathForSelectedCell = [indexPath retain];
#else
        _indexPathForSelectedCell = indexPath;
#endif
		[[self visibleCellForIndexPath:_indexPathForSelectedCell] setSelected:YES animated:animated];
	}
}

/////////////////////////////////////////////////////////////////////////////

-(OHGridViewCell*)dequeueReusableCell
{
	OHGridViewCell* cell = [self.recyclePool anyObject];
	if (cell)
    {
#if ! __has_feature(objc_arc)
		[[cell retain] autorelease];
#endif
		[self.recyclePool removeObject:cell];
        
        cell.backgroundView.frame = cell.bounds;
        cell.selectedBackgroundView.frame = cell.bounds;
        cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        cell.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        cell.selected = NO;
	}
	return cell;
}

-(OHGridViewCell*)visibleCellForIndexPath:(NSIndexPath*)indexPath
{
	for(OHGridViewCell* cell in self.visibleCells)
    {
		if ([cell.indexPath isEqual:indexPath])
        {
			return cell;
		}
	}
	return nil;
}

-(void)layoutSubviews
{
	// remove cells that are no longer visible
	for(UIView* v in self.visibleCells)
    {
		if (!CGRectIntersectsRect(v.frame, self.bounds))
        {
			[self.recyclePool addObject:v];
			[v removeFromSuperview];
		}
	}
	[self.visibleCells minusSet:self.recyclePool];
	
	if (self.itemsCount == 0) return;
	
	// tile missing cells
	NSUInteger firstRow = floorf( CGRectGetMinY(self.bounds) / self.rowHeight );
	firstRow = MAX(firstRow,0);
	NSUInteger lastRow = floorf( (CGRectGetMaxY(self.bounds)-1) / self.rowHeight ) + 1;
	NSUInteger totalNumRows = (self.itemsCount>0) ? ((self.itemsCount-1) / self.columnsCount)+1 : 0;
	lastRow = MIN(lastRow, totalNumRows);
	CGFloat w = self.bounds.size.width / self.columnsCount;
	for(int row = firstRow; row<lastRow; ++row)
    {
		for (NSUInteger col= 0; col < self.columnsCount; ++col)
        {
            NSUInteger itemIndex = row * self.columnsCount + col;
			if (itemIndex >= self.itemsCount) return;
			NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:col];
			OHGridViewCell* cell = [self visibleCellForIndexPath:path];
			if (!cell)
            {
				cell = [self.gridViewDataSource OHGridView:self cellAtIndexPath:path];
				cell.indexPath = path;
				cell.selected = (path == self.indexPathForSelectedCell);
                [self insertSubview:cell atIndex:self.visibleCells.count];
				[self.visibleCells addObject:cell];
			}
			cell.frame = CGRectInset( CGRectMake(col*w, row*self.rowHeight,w,self.rowHeight) , self.marginWidth, self.marginWidth);
			if ([self.gridViewDelegate respondsToSelector:@selector(OHGridView:willDisplayCell:forIndexPath:)])
            {
				[self.gridViewDelegate OHGridView:self willDisplayCell:cell forIndexPath:path];
            }
		}
	}
    
    [super layoutSubviews];
}

@end
