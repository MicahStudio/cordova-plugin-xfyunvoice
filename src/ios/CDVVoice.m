#import "CDVVoice.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation CDVVoice
- (void)pluginInitialize {
    
    NSString* APPID_VALUE = [[self.commandDelegate settings] objectForKey:@"appid"];
    //初始化
       
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];

    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    [self initRecognizer];
    NSLog(@"cordova-plugin-xunfeiyun has been initialized. APP_ID: %@.",  APPID_VALUE);
}
- (void)startVoice:(CDVInvokedUrlCommand *)command {
    
    self.currentCallbackId = command.callbackId;
//请求语音
    
    if(_iflyRecognizerView == nil)
    {
        [self initRecognizer ];
    }
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:@"1" forKey:@"audio_source"];

    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iflyRecognizerView start];
}

/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }

    // NSString* resultText = [NSString stringWithFormat:@"%@%@"];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentCallbackId];
    //_textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,result];
}

/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"errorCode:%d",[error errorCode]);
}
/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示居中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.viewController.view.center];
        
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];

    }
    _iflyRecognizerView.delegate = self;
    
    if (_iflyRecognizerView != nil) {
        //设置最长录音时间
        [_iflyRecognizerView setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iflyRecognizerView setParameter:@"chinese" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
         [_iflyRecognizerView setParameter:@"普通话" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}
@end
