//
//  CategoryViewController.m
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Category:%@",self.barCode);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)categorySelected:(id)sender
{
    switch ([sender tag]) {
        case 0:
            self.selectedCategory = @"Black";
            break;
        case 1:
            self.selectedCategory = @"Red";
            break;
        case 2:
            self.selectedCategory = @"Yellow";
            break;
        case 3:
            self.selectedCategory = @"Green";
            break;
            
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"bodyPart" sender:self];

    self.bodyPartVC = (bodyPartViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"bodyPart"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"bodyPart"])
    {
        self.bodyPartVC = segue.destinationViewController;
        self.bodyPartVC.data = [NSArray arrayWithObjects:self.barCode,self.selectedCategory, nil];
        //        self.bodyPartVC.delegate = self;
    }
}

- (void)setBarCode:(NSString *)barCode
{
    if (self.barCode != barCode)
    {
        _barCode = NULL;
        _barCode = [NSString stringWithFormat:@"%@",barCode];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
