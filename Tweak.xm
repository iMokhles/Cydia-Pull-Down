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