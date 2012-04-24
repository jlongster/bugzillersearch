//
//  BugZillerSearchMasterViewController.m
//  bugzillersearch
//
//  Created by Matthew MacPherson on 12-04-10.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import "BugZillerSearchMasterViewController.h"

#import "BugZillerSearchDetailViewController.h"

#import "GTMHTTPFetcher.h"

@interface BugZillerSearchMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation BugZillerSearchMasterViewController

@synthesize searchBar;
@synthesize tableData;
@synthesize tableView;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem://UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    [self.searchBar becomeFirstResponder];
    
    _objects = [[NSMutableArray alloc] init];
    [_objects insertObject:@"Bug 747029" atIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDate *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

// When we cancel, clear out the text in the search box.
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";

    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some 
    // api that you are using to do the search
    NSString *urlString = [NSString stringWithFormat:@"https://api-dev.bugzilla.mozilla.org/latest/bug?summary=%@", searchBar.text];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    GTMHTTPFetcher* bugzillaSearch = [GTMHTTPFetcher fetcherWithRequest:request];
    [bugzillaSearch beginFetchWithDelegate:self
                    didFinishSelector:@selector(bugzillaSearch:finishedWithData:error:)];
	
    [self.tableData removeAllObjects];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // Existing code
    
    // Fading in the disableViewOverlay
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)bugzillaSearch:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    if (error != nil) {
        // failed; either an NSURLConnection error occurred, or the server returned
        // a status value of at least 300
        //
        // the NSError domain string for server status errors is kGTMHTTPFetcherStatusDomain
        int status = [error code];
    } else {
        // fetch succeeded
        NSLog(@"searched!");
        NSString *resultJSON = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
        NSLog(resultJSON);
        
        NSArray *results = [[NSArray alloc] init];
        
        [searchBar setShowsCancelButton:NO animated:YES];
        [searchBar resignFirstResponder];
        self.tableView.allowsSelection = YES;
        self.tableView.scrollEnabled = YES;
        
        [self.tableData addObjectsFromArray:results];
        [self.tableView reloadData];
    }
}

@end
