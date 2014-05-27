//
//  SPViewController.h
//  SPLogManager
//
//  Created by NathanChang on 2014/5/15.
//  Copyright (c) 2014年 Stupid Pencil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SPViewController : UIViewController<MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *loggerTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *logLevelPicker;

- (IBAction)testLogPrint:(id)sender;
- (IBAction)emailLog:(id)sender;
- (IBAction)emailAllLog:(id)sender;


@end
