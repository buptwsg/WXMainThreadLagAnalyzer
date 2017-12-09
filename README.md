# WXMainThreadLagAnalyzer
自己开发并使用的一款iOS App主线程卡顿分析工具，目前初步实现如下功能：  

* 配置参数，如卡顿判定参数，产生的日志文件的最大数量，是否在release版本生效。
* 通过视图上的开关，可以打开或关闭FPS监控和卡顿监控。
* 在卡顿发生时，获得所有线程的即时堆栈，以供分析原因。
* 在APP内查看日志文件，并通过AirDrop或是邮件，发送到工作电脑。
* 开发者只需要将得到的日志文件存入指定目录，就可以自动得到符号化以后的日志文件。

# 安装
参照下面的步骤来安装并使用：  

* 将目录WXMainThreadLagAnalyzer加入到现有的工程里面，目前使用了PLCrashReporter提供的CrashReporter来得到堆栈，如果你的项目里也有这个framework，注意别加重复了。
* 将symbolicatetool.zip解压到**~/Downloads**目录
* 将createdsym.py拷贝到项目的工程文件所在的目录，并在Build Phrases的最后，加一个Run Script，内容为:`python ${PROJECT_DIR}/createdsym.py`
* 将AutoSymbolicate保存在你喜欢的位置，进入终端，cd到保存位置，运行`./AutoSymbolicate`

# 使用
## 1.配置并启动分析器  
```
#import "AppDelegate.h"
#import "WXLagAnalyzer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    dispatch_async(dispatch_get_main_queue(), ^{
        WXLagAnalyzerConfig *config = [[WXLagAnalyzerConfig alloc] init];
        config.lagCriteria = 40;
        config.lagTimes = 2;
        config.maxNumberOfCrashReports = 5;
        config.checkDuplicate = NO;
        config.enableInReleaseBuild = YES;
        [WXLagAnalyzer startWithConfig: config];
    });
    
    return YES;
}
```

## 2.点击开关来打开FPS和主线程监控  
![](https://github.com/buptwsg/WXMainThreadLagAnalyzer/blob/master/Shots/turnon.PNG)  

## 3.卡顿出现以后，视图变为红色，此时可以点击进入查看
![](https://github.com/buptwsg/WXMainThreadLagAnalyzer/blob/master/Shots/crashlist.PNG)  

## 4.在卡顿详情页面，点击右上角按钮可以传输到工作电脑上
![](https://github.com/buptwsg/WXMainThreadLagAnalyzer/blob/master/Shots/sendtopic.PNG)  

## 5.将日志存入到~/Downloads/symbolicatetool/crashLog目录
运行的AutoSymbolicate小程序，将会监控到有日志文件被写入到上述目录，然后自动运行符号化过程。符号化以后的文件保存在~/Downloads/symbolicatetool/symbolicatecrashLog目录，并自动使用文本编辑程序打开，开发者可以直接查看。 
