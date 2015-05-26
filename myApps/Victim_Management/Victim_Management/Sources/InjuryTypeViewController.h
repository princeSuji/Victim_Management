//
//  InjuryTypeViewController.h
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/19/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTableTableViewController.h"

@interface InjuryTypeViewController : UIViewController

@property (nonatomic, strong)NSArray *data;
@property (nonatomic, strong)NSString *injuryType;
@property (nonatomic, strong)NavigationTableTableViewController *mainViewVC;

- (IBAction)injurySelected:(id)sender;

@end
