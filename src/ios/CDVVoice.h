#import <Cordova/CDV.h>
#import "iflyMSC/IFlyMSC.h"


@class IFlySpeechUnderstander;
@interface CDVVoice : CDVPlugin <IFlyRecognizerViewDelegate>

@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象

@property(nonatomic, strong) NSString *currentCallbackId;
@property(nonatomic, strong) NSString *iosAppId;
- (void)startVoice:(CDVInvokedUrlCommand *)command;
@end