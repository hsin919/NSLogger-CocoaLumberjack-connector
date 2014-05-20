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

-(void)loadConfig;

-(SP_LOG_LEVEL)getLogLevel;
-(void)setLogLevel:(SP_LOG_LEVEL)level;

-(void)setFileLogDebug:(BOOL)enable;
// Enable output for system console
-(void)setASLDebug:(BOOL)enable;
// Enable output for xcode console
-(void)setTTYDebug:(BOOL)enable;
// Enable output for NSLogger
-(void)setNetworkDebug:(BOOL)enable;

- (DDLogFileInfo *)getCurrentLogFileInfo;
- (NSData *)getAllLog;

- (NSString*)formatTypeToString:(SP_LOG_LEVEL)formatType;
@end
