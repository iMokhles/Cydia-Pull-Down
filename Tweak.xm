#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <substrate.h>
#import <iMoMacros.h>

@interface Cydia
- (bool)requestUpdate;
@end

BOOL isSearchPage;
%hook FilteredPackageListController
- (void) viewWillAppear:(BOOL)animated  {
	UITableView *mainList = MSHookIvar<UITableView *>(self, "list_");

	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];

    if (!isSearchPage)
    	[mainList addSubview:refreshControl];

    %orig;

}

%new
-(void)handleRefresh:(UIRefreshControl *)refresh {
	Cydia *cyAppDelegate = (Cydia *)[UIApplication sharedApplication];
	[cyAppDelegate requestUpdate];
	[refresh endRefreshing];
}
%end

%hook SourcesController
- (void) viewWillAppear:(BOOL)animated  {
	UITableView *mainList = MSHookIvar<UITableView *>(self, "list_");

	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mainList addSubview:refreshControl];

    %orig;

}

%new
-(void)handleRefresh:(UIRefreshControl *)refresh {
	Cydia *cyAppDelegate = (Cydia *)[UIApplication sharedApplication];
	[cyAppDelegate requestUpdate];
	 [refresh endRefreshing];
}
%end

%hook SearchController
- (void) viewWillAppear:(BOOL)animated  {
	isSearchPage = YES;
    %orig;

}
- (void) viewDisappear:(BOOL)animated  {
	isSearchPage = NO;
    %orig;

}
%end

/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
