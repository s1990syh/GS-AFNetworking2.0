//
//  MSNetworkState.h
//  Secret
//
//  Created by Song on 14-8-25.
//  Copyright (c) 2014年 GhostSong. All rights reserved.
//
/*
 首先在 AppDelegate.m 的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption方法中加入下面一句代码:
 
 [[GSNetworkTool createNetworkTool] startMonitoringNetwork];
 */


#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

typedef enum _netStateType {
    network_None,       //无网络
    netWork_WWAN,       //蜂窝移动网络
    netWork_Wifi,       //wifi
    network_unknown,    //未知
} netStateType;

@interface GSNetworkTool : NSObject

/**
 *  当前网络类型
 */
@property (nonatomic, assign)netStateType currentNetworkType;


/**
 *   创建单例
 */
+ (GSNetworkTool *)createNetworkTool;

/**
 *  当前网络状态,是否连通
 */
- (BOOL)netIsWork;

/**
 *  开始监视网络
 */
- (void)startMonitoringNetwork;

/**
 *  停止监视网络
 */
- (void)stopMonitoringNetwork;

@end
