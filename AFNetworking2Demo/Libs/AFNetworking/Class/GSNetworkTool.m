//
//  MSNetworkState.m
//  Secret
//
//  Created by Song on 14-8-25.
//  Copyright (c) 2014年 GhostSong. All rights reserved.
//

#import "GSNetworkTool.h"

static GSNetworkTool *_networkTool;

@interface GSNetworkTool()
@property(nonatomic, strong) AFNetworkReachabilityManager *afNetworkReachabilityManager;

@end

@implementation GSNetworkTool

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initNetworkTool];
    }
    return self;
}
- (void)initNetworkTool
{
    self.afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
}
+ (GSNetworkTool *)createNetworkTool;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkTool = [[self alloc] init];
    });
    return _networkTool;
}

- (BOOL)netIsWork
{
    return [self.afNetworkReachabilityManager isReachable];
}
- (void)startMonitoringNetwork
{
    [self.afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    //注册通知, 当网络有变化时, 执行afNetworkStatusChanged:方法
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];

    __block GSNetworkTool *selfBlock = self;

    [self.afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                selfBlock.currentNetworkType = network_None;
                NSLog(@">>>>> 无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                selfBlock.currentNetworkType = netWork_Wifi;
                NSLog(@">>>>> wifi");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                selfBlock.currentNetworkType = netWork_WWAN;
                NSLog(@">>>>> 蜂窝移动网络");
                break;
            }
            default:
                selfBlock.currentNetworkType = network_unknown;
                NSLog(@">>>>> 未知");
                break;
        }
    }];
    NSLog(@">>>>>已开启网络监视");
}
- (void)stopMonitoringNetwork
{
    [self.afNetworkReachabilityManager stopMonitoring];  //停止网络监视器；
    NSLog(@">>>>>已关闭网络监视");
    
}
//网络变化时的操作
//- (void)afNetworkStatusChanged:(NSNotification *)notifi{
//    
//    NSDictionary *info = notifi.userInfo;
//    NSLog(@"------------------------:%u",self.currentNetworkType);
//    if ([info[@"AFNetworkingReachabilityNotificationStatusItem"] intValue] == 0) {
//        
////        [rootVC.view makeToast:@"网络断开"
////                    duration:(kDefaultToastShowTime)
////                    position:kDefaultToastCenter];
//    }else{
////        [rootVC.view makeToast:@"网络已连接"
////                      duration:(kDefaultToastShowTime)
////                      position:kDefaultToastCenter];
//    }
//}
@end
