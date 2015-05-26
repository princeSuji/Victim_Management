//
//  ViewController.m
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import "ViewController.h"
#import "Barcode.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@end


@implementation ViewController
{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    
    //call web service to check if barcode exists
    
    self.detectedBarcode = barcode.barcodeData;
    
    [self getBarcode];
}

- (void)barCodeAnalysisDone
{
    if (self.barcodeFound == NO)
    {
        [self performSegueWithIdentifier:@"Category" sender:self];
        
        self.categoryVC = (CategoryViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"Category"];
    }
    else
    {
        [self inStagingArea];
    }
}

- (void)stagingCheckDone
{
    if (self.inStaging == NO)
    {
        [self addToStagingArea];
    }
    else
    {
        [self performSegueWithIdentifier:@"dispatch" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Category"])
    {
        self.categoryVC = segue.destinationViewController;
        self.categoryVC.barCode = self.detectedBarcode;
//        self.bodyPartVC.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"dispatch"])
    {
        self.dispatchVC = segue.destinationViewController;
        self.dispatchVC.barCode = self.detectedBarcode;
        //        self.bodyPartVC.delegate = self;
    }
}


- (void)getBarcode
{
    NSString *urlString = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=exists",self.detectedBarcode];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    
//    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
//    self.delegate = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data)
        {
            NSLog(@"Reply is:%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
            if ([result isEqualToString:@"false"] == YES)
            {
                self.barcodeFound = NO;
            }
            else
            {
                self.barcodeFound = YES;
            }
            
            [self performSelectorInBackground:@selector(barCodeAnalysisDone) withObject:nil];
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

- (void)inStagingArea
{
    NSString *urlString = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=isStaging",self.detectedBarcode];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data)
        {
            NSLog(@"In Staging is:%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
            if ([result isEqualToString:@"false"] == YES)
            {
                self.inStaging = NO;
            }
            else
            {
                self.inStaging = YES;
            }
            
            [self performSelectorInBackground:@selector(stagingCheckDone) withObject:nil];
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

- (void)addToStagingArea
{
    NSString *urlString = [NSString stringWithFormat:@"http://54.149.57.116:8080/Sample/DBServlet?id=%@&reqtype=addToStaging",self.detectedBarcode];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data)
        {
            NSLog(@"In Staging:%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
            if ([result isEqualToString:@"false"] == YES)
            {
                self.inStaging = NO;
                
                [self performSelectorInBackground:@selector(showAlternateAlert) withObject:nil];
            }
            else
            {
                self.inStaging = NO;
                
                [self performSelectorInBackground:@selector(showAlert) withObject:nil];
            }
            
        }
        else if (error)
            NSLog(@"%@",error);
    }];
}

- (void)showAlert
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Moved to Staging"
                                                      message:@"The victim has been moved to staging area."
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

- (void)showAlternateAlert
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"In Hospital"
                                                      message:@"The victim has been admitted to hospital."
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UINavigationController *navigationController = (UINavigationController *)self.view.window.rootViewController;
    [navigationController popToRootViewControllerAnimated:YES];
}

@end
