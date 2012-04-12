//
//  BugZillerSearchMasterViewController.h
//  bugzillersearch
//
//  Created by Matthew MacPherson on 12-04-10.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BugZillerSearchMasterViewController : UITableViewController <UISearchBarDelegate, UITableViewDataSource> {
    NSMutableArray *tableData;
    
    UITableView *tableView;
    UISearchBar *searchBar;
}

@property(retain) NSMutableArray *tableData;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;


@end