//
//  SPLogManager.h
//  iDoubleTouching
//
//  Created by NathanChang on 2014/5/12.
//  Copyright (c) 2014年 stupid. pencil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDNSLoggerLogger.h"
#import "CompressingLogFileManager.h"

extern int ddLogLevel;

#define DEFAULT_ASL_DEBUG NO
#define DEFAULT_FILE_DEBUG NO
#define DEFAULT_TTY_DEBUG YES
#define DEFAULT_DDNS_DEBUG NO

@interface FileLogConfig : NSObject
@property int maxFileNumber;
@property int rollingFreq;  // in second
@property int fileSize;
@end

typedef enum {
    SP_LOG_OFF = 0,
    SP_LOG_ERROR,
    SP_LOG_WARN,
    SP_LOG_INFO,
    SP_LOG_DEBUG,
    SP_LOG_ALL,
    SP_LOG_LEVEL_COUNT
} SP_LOG_LEVEL;

@interface SPLogManager : NSObject

+(SPLogManager *)getManager;

/**
 *   Load previous log level, ASL logger, and other logger settings for you.
 *   You can also skip loadConfig & setASLDebug, setTTYDebug, and setFileLogDebug manually everytime.
 */
-(void)loadConfig;

/**
 *  Get current log level
 *
 *  @return Log level type
 */
-(SP_LOG_LEVEL)getLogLevel;
-(void)setLogLevel:(SP_LOG_LEVEL)level;

-(void)setFileLogDebug:(BOOL)enable;
/**
 *  Set configuration for file logger. Default value are
 *  Max File Number: 4
 *  RollingFreq: 1 hr
 *  FileSize: 500KB;
 *
 *  @param fileConfig Data wrapper for maxFileNumber, rollingFreq(in second), and fileSize.
 */
- (void)setFileLogConfig:(FileLogConfig *)fileConfig;

/**
 *  Enable output for system console. If true, SPLogManager will add DDASLLogger for you.
 *  Do nothing If DDASLLogger is already added.
 *
 *  @param enable enable
 */
-(void)setASLDebug:(BOOL)enable;

/**
 *  Enable output for system console. If true, SPLogManager will add DDTTYLogger for you.
 *  Do nothing If DDTTYLogger is already added.
 *
 *  @param enable enable
 */
-(void)setTTYDebug:(BOOL)enable;

/**
 *  Enable output for system console. If true, SPLogManager will add DDNSLoggerLogger for you.
 *  Do nothing If DDNSLoggerLogger is already added.
 *
 *  @param enable enable
 */
-(void)setNetworkDebug:(BOOL)enable;

/**
 *  Get current file log info
 *
 *  @return DDLogFileInfo provide the file path, log nsdata, and file name.
 */
- (DDLogFileInfo *)getCurrentLogFileInfo;
/**
 *  Get all rolling files data for mail.
 */
- (NSData *)getAllLog;

- (NSString*)formatTypeToString:(SP_LOG_LEVEL)formatType;
@end
