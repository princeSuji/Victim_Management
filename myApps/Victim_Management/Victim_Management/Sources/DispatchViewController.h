//
//  DispatchViewController.h
//  Victim_Management
//
//  Created by Sujith Achuthan on 4/19/15.
//  Copyright (c) 2015 Sujith Achuthan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DispatchViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong,nonatomic)NSString *barCode;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;
@property (weak, nonatomic) IBOutlet UIButton *ambulanceButton;
@property (weak, nonatomic) IBOutlet UIButton *dispatchButton;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;

@property (strong, nonatomic)NSString *ambulanceName;
@property (strong, nonatomic)NSString *hospitalName;
@property (strong, nonatomic)NSMutableArray *pickerDetails;
@property (strong, nonatomic)NSMutableArray *idDetails;
@property (assign) NSInteger selectedItem;
@property (assign) NSInteger selectedRow;

- (IBAction)hospitalButtonClicked:(id)sender;
- (IBAction)ambulanceButtonClicked:(id)sender;
- (IBAction)dispatchButtonClicked:(id)sender;
- (IBAction)done:(id)sender;

@end
