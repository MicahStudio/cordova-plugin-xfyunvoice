#import <Cordova/CDV.h>
// #import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySetting.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyRecognizerView.h"

@class IFlySpeechUnderstander;
@interface CDVVoice : CDVPlugin <IFlyRecognizerViewDelegate>

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象

@property(nonatomic, strong) NSString *currentCallbackId;
- (void)startVoice:(CDVInvokedUrlCommand *)command;
@end