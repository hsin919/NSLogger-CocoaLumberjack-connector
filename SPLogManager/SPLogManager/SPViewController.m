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

- (void)emailErrorLog:(DDLogFileInfo *)currentLogInfo allLogData:(NSData *)allData
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        if(allData == nil)
        {
            [mailViewController addAttachmentData:[NSData dataWithContentsOfFile:currentLogInfo.filePath] mimeType:@"text/plain" fileName:currentLogInfo.fileName];
        }
        else
        {
            [mailViewController addAttachmentData:allData mimeType:@"text/plain" fileName:currentLogInfo.fileName];
        }
        
        [mailViewController setSubject:currentLogInfo.fileName];
        
        [self presentViewController:mailViewController animated:NO completion:nil];
    }
}

- (IBAction)emailLog:(id)sender {
    DDLogFileInfo *currentLogInfo = [[SPLogManager getManager] getCurrentLogFileInfo];
    if(currentLogInfo != nil) 
    {
        [self emailErrorLog:currentLogInfo allLogData:nil];
    }
}

- (IBAction)emailAllLog:(id)sender {
    NSData *allData = [[SPLogManager getManager] getAllLog];
    DDLogFileInfo *currentLogInfo = [[SPLogManager getManager] getCurrentLogFileInfo];
    if(currentLogInfo != nil && allData != nil)
    {
        [self emailErrorLog:currentLogInfo allLogData:allData];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
