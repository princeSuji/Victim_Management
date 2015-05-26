//
//  CategoryViewController.h
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bodyPartViewController.h"

@interface CategoryViewController : UIViewController

@property (nonatomic, strong)NSString *barCode;
@property (nonatomic, strong)bodyPartViewController *bodyPartVC;
@property (assign) NSString* selectedCategory;

-(IBAction)categorySelected:(id)sender;

@end
