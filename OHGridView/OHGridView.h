/***********************************************************************************
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
 ***********************************************************************************
 *
 * Any comment or suggestion welcome. Referencing this project in your AboutBox is appreciated.
 * Please tell me if you use this class so we can cross-reference our projects.
 *
 ***********************************************************************************/

#import <UIKit/UIKit.h>


/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: OHGridViewCell
/////////////////////////////////////////////////////////////////////////////

@interface OHGridViewCell : UIView {
@private
	NSIndexPath* indexPath;
	UIImageView* imageView;
	UILabel* textLabel;
	BOOL selected;
	UIView* backgroundView;
	UIView* selectedBackgroundView;
}
+(OHGridViewCell*)cell; //!< New cell
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UILabel* textLabel;
@property(nonatomic,retain) UIView* backgroundView;
@property(nonatomic,retain) UIView* selectedBackgroundView;
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
-(void)gridView:(OHGridView*)aGridView willSelectCellAtIndexPath:(NSIndexPath*)indexPath;
-(void)gridView:(OHGridView*)aGridView didSelectCellAtIndexPath:(NSIndexPath*)indexPath;
@end

/////////////////////////////////////////////////////////////////////////////

@interface OHGridView : UIScrollView {
	NSUInteger itemsCount;

	NSMutableSet* visibleCells;
	NSMutableSet* recyclePool;
	NSIndexPath* indexPathForSelectedCell;
}
-(OHGridViewCell*)dequeueReusableCell;
-(void)reloadData;
-(void)deselectSelectedCellsAnimated:(BOOL)animated; //!< Identical to set indexPathForSelectedRow to nil
-(void)setIndexPathForSelectedCell:(NSIndexPath *)indexPath animated:(BOOL)animated;
@property(nonatomic,retain) NSIndexPath* indexPathForSelectedCell;
-(NSInteger)indexForIndexPath:(NSIndexPath*)indexPath; //!< Commodity method to return indexPath.section+columnsCount*indexPath.row (or -1 if nil)

@property(nonatomic,assign) IBOutlet id<OHGridViewDelegate> gridViewDelegate;
@property(nonatomic,assign) IBOutlet id<OHGridViewDataSource> gridViewDataSource;
@property(nonatomic,assign) NSUInteger columnsCount;
@property(nonatomic,assign) CGFloat rowHeight;
@property(nonatomic,assign) CGFloat marginWidth;
@end
