//
//  OHGridView.h
//
//  Created by Olivier on 02/09/10.
//  Copyright 2010 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>


/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: OHGridViewCell
/////////////////////////////////////////////////////////////////////////////

@interface OHGridViewCell : UIView {
	NSIndexPath* indexPath;
	UIImageView* imageView;
	UILabel* textLabel;
}
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UILabel* textLabel;
@end




/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: OHGridView
/////////////////////////////////////////////////////////////////////////////


@class OHGridView;
@protocol OHGridViewDataSource
-(NSUInteger)numberOfItemsInGridView:(OHGridView*)aGridView;
-(OHGridViewCell*)gridView:(OHGridView*)aGridView cellAtIndexPath:(NSIndexPath*)indexPath;
@end

@protocol OHGridViewDelegate <NSObject>
@optional
-(void)gridView:(OHGridView*)aGridView willDisplayCell:(OHGridViewCell*)aCell forIndexPath:(NSIndexPath*)indexPath;
-(void)gridView:(OHGridView*)aGridView didSelectCellAtIndexPath:(NSIndexPath*)indexPath;
@end

/////////////////////////////////////////////////////////////////////////////

@interface OHGridView : UIScrollView {
	id<OHGridViewDelegate> delegate;
	id<OHGridViewDataSource> dataSource;
	
	NSUInteger columnsCount;
	CGFloat rowHeight;
	CGFloat marginWidth;
	NSUInteger itemsCount;

	NSMutableSet* visibleCells;
	NSMutableSet* recyclePool;
}
-(OHGridViewCell*)dequeueReusableCell;
-(void)reloadData;
@property(nonatomic,assign) id<OHGridViewDelegate> delegate;
@property(nonatomic,assign) id<OHGridViewDataSource> dataSource;
@property(nonatomic,assign) NSUInteger columnsCount;
@property(nonatomic,assign) CGFloat rowHeight;
@property(nonatomic,assign) CGFloat marginWidth;
@end
