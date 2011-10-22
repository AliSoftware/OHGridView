# About this framework

This framework allows you to display a grid of views.

Its API is very similar to the API of UITableView : it can reuses/recycle cells to avoid too much allocations and it uses tiling to avoid having a too big memory footprint.

You can configure its properties like rowHeight, columnCount, ...

# How to integrate in your project

You have two options to integrate OHGridView in your projects:

### Prebuild the framework then integrate in your project

This is the recommended solution, as you will probably not modify the OHGridView source code. So you can only build the framework once for all and then use it as any other framework.

To do this first open the OHGridView project and build its "OHGridView Universal Framework" scheme/target.
You will then find the build OHGridView.framework in the "Products" directory of the OHGridView folder.
You can then close the OHGridView.xcodeproj project.

Next, simply add the build framework to your project, as any other framework (Apple frameworks or any other).
You can then `#import <OHGridView/OHGridView.h>` in your own code to import its header.

### Add a build dependency between your project and the OHGridView project

This solution is only useful if you intend to modify the OHGridView source often. You can add the OHGridView.xcodeproj projet as e dependency project of your own project, and add the "OHGridView Universal Framework" target as a dependency project of your own project.

# How to use in your source code

Once you have added OHGridView.framework to your project, you simply `#import <OHGridView/OHGridView.h>` in your source and then implement the methods of the OHGridViewDataSource protocol, like you would do for a UITableView:

-(NSUInteger)numberOfItemsInGridView:(OHGridView *)aGridView;
-(OHGridViewCell*)gridView:(OHGridView *)aGridView cellAtIndexPath:(NSIndexPath *)indexPath;

You can also implement the GridViewDelegate protocol especially to handle when a cell is tapped:
-(void)gridView:(OHGridView *)aGridView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;


See the "GridViewExample" project for a basic usage example (including changing the number of columns used when the iPhone orientation changes)
