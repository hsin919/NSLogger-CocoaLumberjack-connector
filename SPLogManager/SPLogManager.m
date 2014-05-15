//
//  SPLogManager.m
//  iDoubleTouching
//
//  Created by NathanChang on 2014/5/12.
//  Copyright (c) 2014年 stupid. pencil. All rights reserved.
//

#import "SPLogManager.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

#define LOG_LEVEL_KEY @"prefsLogLevel"
#define LOG_DEBUG_ASL_KEY @"LOG_DEBUG_ASL_KEY"
#define LOG_DEBUG_FILE_KEY @"LOG_DEBUG_FILE_KEY"
#define LOG_DEBUG_TTY_KEY @"LOG_DEBUG_TTY_KEY"

int ddLogLevel;

@interface SPLogManager()

@property (nonatomic, strong) DDFileLogger* fileLogger;
@property (nonatomic, strong) DDASLLogger* aslLogger;
@property (nonatomic, strong) DDTTYLogger* ttyLogger;

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

- (int)getMappingLevel:(SP_LOG_LEVEL)level
{
    switch (level) {
        case SP_LOG_OFF:
            return LOG_LEVEL_OFF;
            break;
        case SP_LOG_ERROR:
            return LOG_LEVEL_ERROR;
            break;
        case SP_LOG_WARN:
            return LOG_LEVEL_WARN;
            break;
        case SP_LOG_INFO:
            return LOG_LEVEL_INFO;
            break;
        case SP_LOG_DEBUG:
            return LOG_LEVEL_DEBUG;
            break;
        case SP_LOG_ALL:
            return LOG_LEVEL_VERBOSE;
            break;
        default:
            break;
    }
}

- (void)loadConfig
{
    NSNumber *logLevel = [[NSUserDefaults standardUserDefaults] objectForKey:LOG_LEVEL_KEY];
    if (logLevel)
    {
        ddLogLevel = [logLevel intValue];
        [self printLogLevel];
    }
    
    [self loadASLConfig];
    [self loadFileConfig];
    [self loadTTYConfig];
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
    self.fileLogger = [[DDFileLogger alloc] init];
    _fileLogger.rollingFrequency = 60 * 60 * 24;
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    _fileLogger.maximumFileSize = 1024 * 500; // 500KB;
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
