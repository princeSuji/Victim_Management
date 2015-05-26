//
//  Barcode.h
//  Victim Management
//
//  Created by Sujith Achuthan on 4/18/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Barcode : NSObject

@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadataObject;
@property (nonatomic, strong) NSString * barcodeType;
@property (nonatomic, strong) NSString * barcodeData;
@property (nonatomic, strong) UIBezierPath *cornersPath;
@property (nonatomic, strong) UIBezierPath *boundingBoxPath;

+ (Barcode * )processMetadataObject:(AVMetadataMachineReadableCodeObject*) code;
- (NSString *) getBarcodeType;
- (NSString *) getBarcodeData;
- (void) printBarcodeData;

@end
