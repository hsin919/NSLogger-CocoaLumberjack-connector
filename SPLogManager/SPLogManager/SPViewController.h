//
//  SPViewController.h
//  SPLogManager
//
//  Created by NathanChang on 2014/5/15.
//  Copyright (c) 2014年 Stupid Pencil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *logLevelPicker;

- (IBAction)testLogPrint:(id)sender;


@end
