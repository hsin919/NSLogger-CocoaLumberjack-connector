//
//  SPLogManager.m
//  iDoubleTouching
//
//  Created by NathanChang on 2014/5/12.
//  Copyright (c) 2014年 stupid. pencil. All rights reserved.
//

#import "SPLogManager.h"

#define LOG_LEVEL_KEY @"prefsLogLevel"
#define LOG_DEBUG_ASL_KEY @"LOG_DEBUG_ASL_KEY"
#define LOG_DEBUG_FILE_KEY @"LOG_DEBUG_FILE_KEY"
#define LOG_DEBUG_TTY_KEY @"LOG_DEBUG_TTY_KEY"
#define LOG_DEBUG_NSLOGGER_KEY @"LOG_DEBUG_NSLOGGER_KEY"

int ddLogLevel;

@interface SPLogManager()

@property (nonatomic, strong) DDFileLogger* fileLogger;
@property (nonatomic, strong) DDASLLogger* aslLogger;
@property (nonatomic, strong) DDTTYLogger* ttyLogger;
@property (nonatomic, strong) DDNSLoggerLogger* ddnsLogger;

@property NSDictionary *logTypeValueDict;
@property NSDictionary *logTypeStringDict;

@end
@implementation SPLogManager

static SPLogManager *instance = nil;

- (id)init
{
	self= [super init];
    if(self)
    {
        self.fileLogger = nil;
        self.aslLogger = nil;
        self.ttyLogger = nil;
        self.ddnsLogger = nil;
       
        self.logTypeValueDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:LOG_LEVEL_OFF], [NSNumber numberWithInt:SP_LOG_OFF],
                                [NSNumber numberWithInt:LOG_LEVEL_ERROR], [NSNumber numberWithInt:SP_LOG_ERROR],
                                [NSNumber numberWithInt:LOG_LEVEL_WARN], [NSNumber numberWithInt:SP_LOG_WARN],
                                [NSNumber numberWithInt:LOG_LEVEL_INFO], [NSNumber numberWithInt:SP_LOG_INFO],
                                [NSNumber numberWithInt:LOG_LEVEL_DEBUG], [NSNumber numberWithInt:SP_LOG_DEBUG],
                                [NSNumber numberWithInt:LOG_LEVEL_VERBOSE], [NSNumber numberWithInt:SP_LOG_ALL]
                                 ,nil];
        
        self.logTypeStringDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"SP_LOG_OFF", [NSNumber numberWithInt:SP_LOG_OFF],
                                  @"SP_LOG_ERROR", [NSNumber numberWithInt:SP_LOG_ERROR],
                                  @"SP_LOG_WARN", [NSNumber numberWithInt:SP_LOG_WARN],
                                  @"SP_LOG_INFO", [NSNumber numberWithInt:SP_LOG_INFO],
                                  @"SP_LOG_DEBUG", [NSNumber numberWithInt:SP_LOG_DEBUG],
                                  @"SP_LOG_ALL", [NSNumber numberWithInt:SP_LOG_ALL]
                                  ,nil];
    }
	return self;
}

- (void)loadASLConfig
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:LOG_DEBUG_ASL_KEY])
    {
        BOOL enable = [[NSUserDefaults standardUserDefaults] boolForKey:LOG_DEBUG_ASL_KEY];
        [self setASLDebug:enable];
    }
    else
    {
        [self setASLDebug:DEFAULT_ASL_DEBUG];
    }
}

- (void)loadFileConfig
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:LOG_DEBUG_FILE_KEY])
    {
        BOOL enable = [[NSUserDefaults standardUserDefaults] boolForKey:LOG_DEBUG_FILE_KEY];
        [self setFileLogDebug:enable];
    }
    else
    {
        [self setFileLogDebug:DEFAULT_FILE_DEBUG];
    }
}

- (void)loadTTYConfig
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:LOG_DEBUG_TTY_KEY])
    {
        BOOL enable = [[NSUserDefaults standardUserDefaults] boolForKey:LOG_DEBUG_TTY_KEY];
        [self setTTYDebug:enable];
    }
    else
    {
        [self setTTYDebug:DEFAULT_TTY_DEBUG];
    }
}

- (void)loadDDNSConfig
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:LOG_DEBUG_NSLOGGER_KEY])
    {
        BOOL enable = [[NSUserDefaults standardUserDefaults] boolForKey:LOG_DEBUG_NSLOGGER_KEY];
        [self setNetworkDebug:enable];
    }
    else
    {
        [self setNetworkDebug:DEFAULT_DDNS_DEBUG];
    }
}

- (void)printLogLevel
{
    switch (ddLogLevel) {
        case LOG_LEVEL_OFF:
            NSLog(@"LOG_LEVEL_OFF");
            break;
        case LOG_LEVEL_ERROR:
            NSLog(@"LOG_LEVEL_ERROR");
            break;
        case LOG_LEVEL_WARN:
            NSLog(@"LOG_LEVEL_WARN");
            break;
        case LOG_LEVEL_INFO:
            NSLog(@"LOG_LEVEL_INFO");
            break;
        case LOG_LEVEL_DEBUG:
            NSLog(@"LOG_LEVEL_DEBUG");
            break;
        case LOG_LEVEL_VERBOSE:
            NSLog(@"LOG_LEVEL_VERBOSE");
            break;
        default:
            NSLog(@"Unknowm Log level:%i", ddLogLevel);
            break;
    }
}

-(SP_LOG_LEVEL)getLogLevel
{
    NSArray *temp = [self.logTypeValueDict allKeysForObject:[NSNumber numberWithInt:ddLogLevel]];
    SP_LOG_LEVEL level = [[temp lastObject] intValue];
    return level;
}

- (int)getMappingLevel:(SP_LOG_LEVEL)level
{
    int ddLevel = [[self.logTypeValueDict objectForKey:[NSNumber numberWithInt:level]] intValue];
    return ddLevel;
}

- (void)loadConfig
{
    int logLevel = [[NSUserDefaults standardUserDefaults] integerForKey:LOG_LEVEL_KEY];
    if (logLevel)
    {
        ddLogLevel = logLevel;
        [self printLogLevel];
    }
    
    [self loadASLConfig];
    [self loadFileConfig];
    [self loadTTYConfig];
    [self loadDDNSConfig];
}

-(void)saveLogLevel:(int)level
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:level forKey:LOG_LEVEL_KEY];
}

-(void)setLogLevel:(SP_LOG_LEVEL)level
{
    ddLogLevel = [self getMappingLevel:level];;
    [self saveLogLevel:ddLogLevel];
}

- (void)clearFileLogger
{
    [DDLog removeLogger:self.fileLogger];
    self.fileLogger = nil;
}

- (void)initFileLogger
{
    CompressingLogFileManager *logFileManager = [[CompressingLogFileManager alloc] init];
    
    self.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    
    _fileLogger.maximumFileSize  = 1024 * 1;  // 1 KB
    _fileLogger.rollingFrequency =   60 * 1;  // 1 Minute
    
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    
    //self.fileLogger = [[DDFileLogger alloc] init];
    //_fileLogger.rollingFrequency = 60 * 60 * 24;
    //_fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    //_fileLogger.maximumFileSize = 1024 * 500; // 500KB;
    [DDLog addLogger:_fileLogger];
}

-(void)setFileLogDebug:(BOOL)enable
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enable forKey:LOG_DEBUG_FILE_KEY];
    
    if(!enable )
    {
        [self clearFileLogger];
    }
    else
    {
        if(self.fileLogger == nil)
        {
            [self initFileLogger];
        }
    }
}
// Enable output for system console
-(void)setASLDebug:(BOOL)enable
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enable forKey:LOG_DEBUG_ASL_KEY];
    if(enable)
    {
        if(_aslLogger == nil)
        {
            _aslLogger = [DDASLLogger sharedInstance];
            [DDLog addLogger:[DDASLLogger sharedInstance]];
        }
    }
    else
    {
        [DDLog removeLogger:[DDASLLogger sharedInstance]];
        _aslLogger = nil;
    }
}
// Enable output for xcode console
-(void)setTTYDebug:(BOOL)enable
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enable forKey:LOG_DEBUG_TTY_KEY];
    if(enable)
    {
        if(_ttyLogger == nil)
        {
            self.ttyLogger = [DDTTYLogger sharedInstance];
            [DDLog addLogger:_ttyLogger];
        }
    }
    else
    {
        [DDLog removeLogger:[DDTTYLogger sharedInstance]];
        self.ttyLogger = nil;
    }
}

-(void)setNetworkDebug:(BOOL)enable
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enable forKey:LOG_DEBUG_NSLOGGER_KEY];
    if(enable)
    {
        if(_ddnsLogger == nil)
        {
            self.ddnsLogger = [DDNSLoggerLogger sharedInstance];
            [_ddnsLogger setupWithBonjourServiceName:@"SPLogManagerServer"];
            [DDLog addLogger:_ddnsLogger];
        }
    }
    else
    {
        [DDLog removeLogger:[DDNSLoggerLogger sharedInstance]];
        self.ddnsLogger = nil;
    }
}

- (DDLogFileInfo *)getCurrentLogFileInfo
{
    NSArray *sortedLogFileInfos = [self.fileLogger.logFileManager sortedLogFileInfos];
    NSLog(@">>> sortedLogFileInfos%@", sortedLogFileInfos);
    if([sortedLogFileInfos count] > 0)
    {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:0];
        //NSData *fileData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        return logFileInfo;
    }
    return nil;
}

- (NSData *)getAllLog
{
    NSMutableData *errorLogData = [NSMutableData data];
    
    NSArray *sortedLogFileInfos = [self.fileLogger.logFileManager sortedLogFileInfos];
    for (int i = 0; i < MIN(sortedLogFileInfos.count, self.fileLogger.logFileManager.maximumNumberOfLogFiles); i++) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:i];
        NSData *fileData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        [errorLogData appendData:fileData];
    }
    return errorLogData;
}

- (NSString*)formatTypeToString:(SP_LOG_LEVEL)formatType {
    return [self.logTypeStringDict objectForKey:[NSNumber numberWithInt:formatType]];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(SPLogManager *) getManager
{
    if (instance == nil) {
        instance = [[SPLogManager alloc] init];
    }
    return instance;
}

@end
