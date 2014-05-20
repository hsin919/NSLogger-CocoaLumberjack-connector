# SPLogManager #
SPLogManager is a simple class which manage [CocoaLumberjack](http://github.com/robbiehanson/CocoaLumberjack) and 
[NSLogger](http://github.com/fpillet/NSLogger).
SPLogManager provide dynamic log level with type checking.
```objective-c
typedef enum {
    SP_LOG_OFF = 0,
    SP_LOG_ERROR,
    SP_LOG_WARN,
    SP_LOG_INFO,
    SP_LOG_DEBUG,
    SP_LOG_ALL,
    SP_LOG_LEVEL_COUNT
} SP_LOG_LEVEL; 
```
You can also enable/disable DDTTYLogger, DDFileLogger, DDASLLogger, and [DDNSLoggerLogger](https://github.com/steipete/NSLogger-CocoaLumberjack-connector) dynamically.
SPLogManager will remember your config automatically.

# Requirements #

SPLogManager is an ARC object.
* [cocoaPods](http://cocoapods.org) : Please run "pod install" before running SPLogManager sample.


# Adding SPLogManager to your project #
Add the following framework to your podfile.
* [NSLogger](http://github.com/fpillet/NSLogger)
* [CocoaLumberjack](http://github.com/robbiehanson/CocoaLumberjack)
Add the following source file to your project
* SPLogManager.m SPLogManager.h
* DDNSLoggerLogger.m DDNSLoggerLogger.h [DDNSLoggerLogger](https://github.com/steipete/NSLogger-CocoaLumberjack-connector)

# Sample code #
At the beginning.
```objective-c
[[SPLogManager getManager] loadConfig];
```
Ex: 
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
Enable or disable the logger you want via UI or any procedure you want.
```objective-c
    [[SPLogManager getManager] setTTYDebug:YES];
    [[SPLogManager getManager] setASLDebug:YES];
    [[SPLogManager getManager] setFileLogDebug:YES];
```
