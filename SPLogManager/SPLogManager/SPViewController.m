//
//  SPViewController.m
//  SPLogManager
//
//  Created by NathanChang on 2014/5/15.
//  Copyright (c) 2014年 Stupid Pencil. All rights reserved.
//

#import "SPViewController.h"
#import "SPLogManager.h"

@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int logLevel = [[SPLogManager getManager] getLogLevel];
	[self.logLevelPicker selectRow:logLevel inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testLogPrint:(id)sender {
    DDLogError(@"%@: Error", THIS_FILE);
    DDLogWarn(@"%@: Warn", THIS_FILE);
    DDLogInfo(@"%@: Info", THIS_FILE);
    DDLogDebug(@"%@: Debug", THIS_FILE);
    DDLogVerbose(@"%@: Verbose", THIS_FILE);
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return SP_LOG_LEVEL_COUNT;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[SPLogManager getManager] formatTypeToString:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[SPLogManager getManager] setLogLevel:row];
}
@end
