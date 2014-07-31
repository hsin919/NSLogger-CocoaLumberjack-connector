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

@property (nonatomic, strong) UISwitch *loggerASL;
@property (nonatomic, strong) UISwitch *loggerX;
@property (nonatomic, strong) UISwitch *loggerNetwork;
@property (nonatomic, strong) UISwitch *loggerFile;

@end

@implementation SPViewController

- (void)initSwitchStatus
{
    self.loggerASL.on = [[SPLogManager getManager] isASLEnable];
    self.loggerFile.on = [[SPLogManager getManager] isFileLoggerEnable];
    self.loggerNetwork.on = [[SPLogManager getManager] isNetworkEnable];
    self.loggerX.on = [[SPLogManager getManager] isTTYEnable];
}

- (void)changeSwitch:(id)sender{
    if(self.loggerASL == sender)
    {
        [[SPLogManager getManager] setASLDebug:self.loggerASL.on];
    }
    else if(self.loggerFile == sender)
    {
        [[SPLogManager getManager] setFileLogDebug:self.loggerFile.on];
    }
    else if(self.loggerNetwork == sender)
    {
        [[SPLogManager getManager] setNetworkDebug:self.loggerNetwork.on];
    }
    else if(self.loggerX == sender)
    {
        [[SPLogManager getManager] setTTYDebug:self.loggerX.on];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loggerASL = [[UISwitch alloc] init];
    [self.loggerASL addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    self.loggerFile = [[UISwitch alloc] init];
    [self.loggerFile addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    self.loggerNetwork = [[UISwitch alloc] init];
    [self.loggerNetwork addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    self.loggerX = [[UISwitch alloc] init];
    [self.loggerX addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [self initSwitchStatus];
    
    [DDLog flushLog];
    
    int logLevel = [[SPLogManager getManager] getLogLevel];
	[self.logLevelPicker selectRow:logLevel inComponent:0 animated:NO];
    
    self.loggerTableView.delegate = self;
    self.loggerTableView.dataSource = self;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Logger";
    }
    else if(section == 1)
    {
        return @"File logger";
    }
    else
    {
        return @"Others";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 3;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DebugConfigCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Log to xcode console";
            cell.accessoryView = self.loggerX;
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Apple system logger";
            cell.accessoryView = self.loggerASL;
        }
        else
        {
            cell.textLabel.text = @"Network debug";
            cell.accessoryView = self.loggerNetwork;
        }
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"File logger";
                cell.accessoryView = self.loggerFile;
                break;
            case 1:
            {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.tag=indexPath.row;
                [button addTarget:self
                           action:@selector(emailLog:) forControlEvents:UIControlEventTouchDown];
                [button setTitle:@"Email current file" forState:UIControlStateNormal];
                button.frame = CGRectMake(50.0, 0.0, 160.0, 40.0);
                [cell.contentView addSubview:button];
                cell.accessoryView = nil;
            }
                break;
            case 2:
            {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.tag=indexPath.row;
                [button addTarget:self
                           action:@selector(emailAllLog:) forControlEvents:UIControlEventTouchDown];
                [button setTitle:@"Email all log file" forState:UIControlStateNormal];
                button.frame = CGRectMake(50.0, 0.0, 160.0, 40.0);
                [cell.contentView addSubview:button];
                cell.accessoryView = nil;
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
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
    SP_LOG_LEVEL logLevel = (int)row;
    return [[SPLogManager getManager] formatTypeToString:logLevel];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SP_LOG_LEVEL logLevel = (int)row;
    [[SPLogManager getManager] setLogLevel:logLevel];
}
@end
