//
//  InjuryTypeViewController.m
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/19/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import "InjuryTypeViewController.h"

@interface InjuryTypeViewController ()

@end

@implementation InjuryTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Injury of body:%@", self.data[2]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData:(NSArray *)data
{
    if (_data != data)
    {
        _data = NULL;
        _data = [NSArray arrayWithObjects:data[0],data[1],data[2],nil];
    }
}

- (IBAction)injurySelected:(id)sender
{
    
    switch ([sender tag])
    {
        case 0:
            self.injuryType = @"Blunt Trauma";
            break;
        case 1:
            self.injuryType = @"Burn";
            break;
        case 2:
            self.injuryType = @"C-Spine";
            break;
        case 3:
            self.injuryType = @"Cardiac";
            break;
        case 4:
            self.injuryType = @"Crushing";
            break;
        case 5:
            self.injuryType = @"Fracture";
            break;
        case 6:
            self.injuryType = @"Laceration";
            break;
        case 7:
            self.injuryType = @"Penetration";
            break;
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"mainView" sender:self];
    
    NSArray *finalDataArray = [NSArray arrayWithObjects:self.data[0],self.data[1],self.data[2],self.injuryType, nil];
    
    [self addVictim:finalDataArray];
}

- (void)addVictim:(NSArray*)data
{
    NSString *sampleUrl = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=add&status=%@&bodyPart=%@&injury=%@&staging=0&enRoute=On Site", data[0],data[1],data[2], data[3]];
    NSString* urlString = [sampleUrl stringByAddingPercentEscapesUsingEncoding:
                           NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    
    //    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    //    self.delegate = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data)
        {
            NSLog(@"Added successfully");
            
            UINavigationController *navigationController = (UINavigationController *)self.view.window.rootViewController;
            [navigationController popToRootViewControllerAnimated:YES];
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

@end
