//
//  DispatchViewController.m
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/19/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import "DispatchViewController.h"

@interface DispatchViewController ()

@end

@implementation DispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Dispatch:%@", self.barCode);
    self.dispatchButton.enabled = NO;
    self.ambulanceName = @"";
    self.hospitalName = @"";
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerDetails = [[NSMutableArray alloc] init];
    self.idDetails = [[NSMutableArray alloc] init];
    self.selectedItem = 0;
    
    [self hidePicker];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)hospitalButtonClicked:(id)sender
{
    self.selectedItem = 1;
    
    NSString *urlString = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=getHospital",self.barCode];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (data)
        {
            NSLog(@"Hospital Data:%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSArray *hospitalArray = [result componentsSeparatedByString:@";"];
            
            for (NSString *currentItem in hospitalArray)
            {
                if(currentItem.length > 0)
                {
                    NSArray *tempArray = [currentItem componentsSeparatedByString:@","];
                    NSString *valueString = [NSString stringWithFormat:@"%@", tempArray[1]];
                
                    [self.pickerDetails addObject:valueString];
                    [self.idDetails addObject:tempArray[0]];
                }
            }
            
            [self performSelectorInBackground:@selector(showPicker) withObject:nil];
            
        }
        else if (error)
            NSLog(@"%@",error);
    }];

}

- (IBAction)ambulanceButtonClicked:(id)sender
{
    self.selectedItem = 2;
    
    NSString *urlString = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=getAmbulance",self.barCode];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (data)
        {
            NSLog(@"Hospital Data:%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSArray *ambulanceArray = [result componentsSeparatedByString:@";"];
            
            for (NSString *currentItem in ambulanceArray)
            {
                if(currentItem.length > 0)
                {
                    NSArray *tempArray = [currentItem componentsSeparatedByString:@","];
                    NSString *valueString = [NSString stringWithFormat:@"%@ <%@>", tempArray[1],tempArray[2]];
                
                    [self.pickerDetails addObject:valueString];
                    [self.idDetails addObject:tempArray[0]];
                }
            }
            
            [self performSelectorInBackground:@selector(showPicker) withObject:nil];
            
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

- (IBAction)dispatchButtonClicked:(id)sender
{
    self.selectedItem = 0;
    
    NSString *urlString = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=dispatch&ambulance=%@&hospital=%@",self.barCode,self.ambulanceName,self.hospitalName];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (data)
        {
            NSLog(@"Hospital Data:%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            
            [self performSelectorInBackground:@selector(dispatchDone) withObject:nil];
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

- (void)dispatchDone
{
    UINavigationController *navigationController = (UINavigationController *)self.view.window.rootViewController;
    [navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerDetails count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerDetails[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
    
}

- (IBAction)done:(id)sender
{
    if (self.selectedItem == 1)
    {
        self.hospitalButton.titleLabel.text = self.pickerDetails[self.selectedRow];
        self.hospitalName = self.idDetails[self.selectedRow];
    }
    else if (self.selectedItem == 2)
    {
        self.ambulanceButton.titleLabel.text = self.pickerDetails[self.selectedRow];
        self.ambulanceName = self.idDetails[self.selectedRow];
    }
    
    [self.pickerDetails removeAllObjects];
    
    [self hidePicker];
    
    if (self.hospitalName.length > 0 && self.ambulanceName.length > 0)
    {
        self.dispatchButton.enabled = YES;
    }
}

- (void)hidePicker {
    
//    self.viewForPicker.alpha = 0;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.viewForPicker.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         NSLog(@"Hidden");
                     }];
}

- (void)showPicker
{
//    self.viewForPicker.alpha = 1;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.viewForPicker.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         NSLog(@"Shown");
                     }];
    
    
    [self.pickerView reloadAllComponents];
    [self.viewForPicker setNeedsDisplay];
    [self.view setNeedsDisplay];
}

@end
