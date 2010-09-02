//
//  GridView.h
//  Clementine
//
//  Created by Olivier on 02/09/10.
//  Copyright 2010 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>


/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: GridViewCell
/////////////////////////////////////////////////////////////////////////////

@interface GridViewCell : UIView {
	NSIndexPath* indexPath;
	UIImageView* imageView;
	UILabel* textLabel;
}
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UILabel* textLabel;
@end




/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: GridView
/////////////////////////////////////////////////////////////////////////////


@class GridView;
@protocol GridViewDataSource
-(NSUInteger)numberOfItemsInGridView:(GridView*)aGridView;
-(GridViewCell*)gridView:(GridView*)aGridView cellAtIndexPath:(NSIndexPath*)indexPath;
@end

@protocol GridViewDelegate <NSObject>
@optional
-(void)gridView:(GridView*)aGridView willDisplayCell:(GridViewCell*)aCell forIndexPath:(NSIndexPath*)indexPath;
-(void)gridView:(GridView*)aGridView didSelectCellAtIndexPath:(NSIndexPath*)indexPath;
@end

/////////////////////////////////////////////////////////////////////////////

@interface GridView : UIScrollView {
	id<GridViewDelegate> delegate;
	id<GridViewDataSource> dataSource;
	
	NSUInteger columnsCount;
	CGFloat rowHeight;
	CGFloat marginWidth;
	NSUInteger itemsCount;

	NSMutableSet* visibleCells;
	NSMutableSet* recyclePool;
}
-(GridViewCell*)dequeueReusableCell;
-(void)reloadData;
@property(nonatomic,assign) id<GridViewDelegate> delegate;
@property(nonatomic,assign) id<GridViewDataSource> dataSource;
@property(nonatomic,assign) NSUInteger columnsCount;
@property(nonatomic,assign) CGFloat rowHeight;
@property(nonatomic,assign) CGFloat marginWidth;
@end
