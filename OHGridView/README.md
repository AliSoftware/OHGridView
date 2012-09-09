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

# ARC Support

**`OHGridView` is compatible with both ARC and non-ARC projects**.

In fact, as `OHGridView` is provided as a separated project, it has its own build settings (that's the advantage of integrating it as a separate project in your workspace, compared to directly add the `OHGridView.h`/`OHGridView.m` files to your application project). As a consequence, the build settings of your own application, including the activation of ARC or not, won't affect `OHGridView` project's build settings and the `OHGridView` building operation.

Moreover, as a matter of fact, the `OHGridView` project itself can be **both compiled with ARC turned on or off**, thanks to `#if` precompiler directives.

* This means that even if it is not the recommanded way to include `OHGridView`in your application, including the files directly in your own xcodeproj will still work, whatever the ARC setting is for your project.
* This also means that even if the `OHGridView` project is currently configured to be compiled with ARC turned on, you may turn this setting off if you prefer (for whatever reason) have the `OHGridView.m` file being compiled without ARC.

In short, whether your project uses ARC or not won't matter, you can use `OHGridView` in any case.

# Feedback

Don't hesitate to contact me if you use this class so we can cross-reference our projects, or if you have any feedback.
