//
//  BugZillerSearchDetailViewController.h
//  bugzillersearch
//
//  Created by Matthew MacPherson on 12-04-10.
//  Copyright (c) 2012 Mozilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BugZillerSearchDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
