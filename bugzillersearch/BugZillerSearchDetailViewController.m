//
//  BugZillerSearchDetailViewController.m
//  bugzillersearch
//
//  Created by Matthew MacPherson on 12-04-10.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import "BugZillerSearchDetailViewController.h"

@interface BugZillerSearchDetailViewController ()
- (void)configureView;
@end

@implementation BugZillerSearchDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize webView = _webView;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];


        NSURL *url = [NSURL URLWithString:@"https://bugzilla.mozilla.org/show_bug.cgi?id=747029"];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [_webView loadRequest: requestObj];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
