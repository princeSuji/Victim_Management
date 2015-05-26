//
//  ViewController.h
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
#import "DispatchViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) NSMutableArray *allowedBarcodeTypes;
@property (strong, nonatomic) CategoryViewController *categoryVC;
@property (strong, nonatomic) DispatchViewController *dispatchVC;
@property (strong, nonatomic) NSString *detectedBarcode;
@property (assign) BOOL barcodeFound;
@property (assign) BOOL inStaging;

@end

