//
//  bodyPartViewController.h
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InjuryTypeViewController.h"

@interface bodyPartViewController : UIViewController
{
    
}

@property (nonatomic, strong)NSArray *data;
@property (weak, nonatomic) IBOutlet UILabel *bodyPartLabel;
@property (strong, nonatomic)NSString *bodyPart;
@property (strong, nonatomic)InjuryTypeViewController *injuryVC;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImage;

- (IBAction)next:(id)sender;

@end
