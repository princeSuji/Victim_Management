//
//  bodyPartViewController.m
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import "bodyPartViewController.h"

@interface bodyPartViewController ()

@end

@implementation bodyPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.myNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(next:)];
    
    NSLog(@"Body Part:%@", self.data[0]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender
{
    [self performSegueWithIdentifier:@"injuryType" sender:self];
    
    self.injuryVC = (InjuryTypeViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"injuryType"];
}

- (void)setData:(NSArray *)data
{
    if (_data != data)
    {
        _data = NULL;
        _data = [NSArray arrayWithObjects:data[0],data[1],nil];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.bodyImage];
    BOOL bodyPartSelected = NO;
    
    CGRect totalRect = self.bodyImage.frame;
    
    int topY = totalRect.size.height *1/6;
    int midY = totalRect.size.height *1/2;
    int leftX = (totalRect.size.width *1/3)+10;
    int rightX = (totalRect.size.width *2/3)-10;
    int midX = (totalRect.size.width *1/2);
    
    
    if (touchLocation.x >=leftX && touchLocation.x< rightX && touchLocation.y < topY)
    {
        NSLog(@"Head");
        self.bodyPartLabel.text = @"Head";
        bodyPartSelected = YES;
    }
    else if (touchLocation.x >=5 && touchLocation.x< leftX && touchLocation.y>topY && touchLocation.y < midY)
    {
        NSLog(@"Left Hand");
        self.bodyPartLabel.text = @"Left Arm";
        bodyPartSelected = YES;
    }
    else if (touchLocation.x >=rightX && touchLocation.x< totalRect.size.width-5 && touchLocation.y>topY && touchLocation.y < midY)
    {
        NSLog(@"Right Hand");
        self.bodyPartLabel.text = @"Right Arm";
        bodyPartSelected = YES;
    }
    else if (touchLocation.x >=leftX && touchLocation.x< rightX && touchLocation.y>topY && touchLocation.y < midY)
    {
        NSLog(@"Torso");
        self.bodyPartLabel.text = @"Torso";
        bodyPartSelected = YES;
    }
    else if (touchLocation.x >=leftX && touchLocation.x< midX && touchLocation.y>midY && touchLocation.y < totalRect.size.height-10)
    {
        NSLog(@"Left Leg");
        self.bodyPartLabel.text = @"Left Leg";
        bodyPartSelected = YES;
    }
    else if (touchLocation.x >=midX && touchLocation.x< rightX && touchLocation.y>midY && touchLocation.y < totalRect.size.height-10)
    {
        NSLog(@"Right Leg");
        self.bodyPartLabel.text = @"Right Leg";
        bodyPartSelected = YES;
    }
    
    if(bodyPartSelected == YES)
    {
        self.bodyPart = self.bodyPartLabel.text;
        [self next:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"injuryType"])
    {
        self.injuryVC = segue.destinationViewController;
        self.injuryVC.data = [NSArray arrayWithObjects:self.data[0],self.data[1],self.bodyPart, nil];
        //        self.bodyPartVC.delegate = self;
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
