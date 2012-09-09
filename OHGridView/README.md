# About this framework

This framework allows you to display a grid of views.

Its API is very similar to the API of UITableView : it can reuses/recycle cells to avoid too much allocations and it uses tiling to avoid having a too big memory footprint.

You can configure its properties like rowHeight, columnCount, ...

# How to integrate in your project

* Add the OHGridView project to your Xcode4 workspace
* Go to your application project's Build Phases (select your application project in the Project Navigator, then select the "Build Phases" tab), expand the "Link binariy with libraries" section and click on the "+" button to add libOHGridView that should be proposed in the list now
* In your application project's Build Settings (select your application project in the Project Navigator, then select the "Build Settings" tab), add `${SRCROOT}/../OHGridView` — or whatever the path to the OHGridView folder is, relative to your project root `${SRCROOT}` — to the "User Header Search Path" setting so you can `#import "OHGridView.h"`.


# How to use in your source code

Once you have added added the OHGridView.xcodeproj to your workspace and configured your application project like described above, you can simply `#import "OHGridView.h"` in your source and then implement the methods of the `OHGridViewDataSource` protocol, like you would do for a `UITableView`:

    -(NSUInteger)numberOfItemsInGridView:(OHGridView *)aGridView;
    -(OHGridViewCell*)gridView:(OHGridView *)aGridView cellAtIndexPath:(NSIndexPath *)indexPath;

You can also implement the GridViewDelegate protocol especially to handle when a cell is tapped:

    -(void)gridView:(OHGridView *)aGridView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;


See the "GridViewExample" project for a basic usage example (including changing the number of columns used when the iPhone orientation changes)

# Feedback

Don't hesitate to contact me if you use this class so we can cross-reference our projects, or if you have any feedback.
