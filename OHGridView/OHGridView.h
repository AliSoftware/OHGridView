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

#import <UIKit/UIKit.h>


/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHGridViewCell Interface

@interface OHGridViewCell : UIView
+(OHGridViewCell*)cell; //!< Commodity constructor
@property(nonatomic,retain) IBOutlet UIImageView* imageView;
@property(nonatomic,retain) IBOutlet UILabel* textLabel;
@property(nonatomic,retain) IBOutlet UIView* backgroundView;
@property(nonatomic,retain) IBOutlet UIView* selectedBackgroundView;
@end




/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHGridView Delegate & DataSource Protocols

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
#pragma mark - OHGridView Interface

@interface OHGridView : UIScrollView
-(OHGridViewCell*)dequeueReusableCell;
-(void)reloadData;
-(void)setIndexPathForSelectedCell:(NSIndexPath *)indexPath animated:(BOOL)animated;
@property(nonatomic,retain) NSIndexPath* indexPathForSelectedCell;
//! Identical to set indexPathForSelectedRow to nil
-(void)deselectSelectedCellsAnimated:(BOOL)animated;
//! Commodity method to return indexPath.section+columnsCount*indexPath.row (or -1 if nil)
-(NSInteger)indexForIndexPath:(NSIndexPath*)indexPath;

@property(nonatomic,assign) IBOutlet id<OHGridViewDelegate> gridViewDelegate;
@property(nonatomic,assign) IBOutlet id<OHGridViewDataSource> gridViewDataSource;
@property(nonatomic,assign) NSUInteger columnsCount;
@property(nonatomic,assign) CGFloat rowHeight;
@property(nonatomic,assign) CGFloat marginWidth;
@end
