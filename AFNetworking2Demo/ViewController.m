//
//  ViewController.m
//  AFNetworking2Demo
//
//  Created by Song on 14-10-9.
//  Copyright (c) 2014年 GhostSong. All rights reserved.
//

#import "ViewController.h"
#import "GSNetworkTool.h"
#import "GSNetRequest.h"
#include <sys/sysctl.h>
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, GSNetRequestDelegate>
@property (nonatomic) NSArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"POST请求", @"POST请求Block", @"GET请求", @"GET请求 带参数", @"GET请求Block", @"GET请求Block 带参数"];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"---------UUID:%@",[UIDevice currentDevice].identifierForVendor.UUIDString);
    NSLog(@"设备型号:%@", [self getCurrentDeviceModel]);
    
    
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size,NULL, 0);
    NSString *machinePlatform = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    free(answer);
    NSLog(@"%@",machinePlatform);
    
    
//    IOS-获取Model（设备型号）、Version（设备版本号）、app（程序版本号）等
    
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
    
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app名称
    
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    // app版本
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // app build版本
    
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    

    
//    [netRequest requestURL:@"http://api.meishi.cc/v2/lanmu.php?format=json" parameters:nil];
//    [netRequest requestURL:@"http://api.meishi.cc/v2/lanmu.php" parameters:@{@"format":@"json"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goButtonPress:(id)sender {
    NSLog(@"当前网络类型========:%u",[GSNetworkTool createNetworkTool].currentNetworkType);
    NSLog(@"网络是否连通--------:%d",[[GSNetworkTool createNetworkTool] netIsWork]);
}

- (IBAction)postRequestWithParameter:(id)sender {
}


# pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    if (indexPath.row == 0) {
        GSNetRequest *netRequest = [[GSNetRequest alloc] init];
        netRequest.delegate = self;
        netRequest.tag = indexPath.row;
        [netRequest postRequestCompleteURLStr:@"http://api.meishi.cc/v2/lanmu.php" parameters:@{@"format":@"json"}];
       
    }
    if (indexPath.row == 1) {
        GSNetRequest *netRequest = [[GSNetRequest alloc] init];
        [netRequest postRequestBlockURLStr:@"http://api.meishi.cc/v2/lanmu.php" parameters:@{@"format":@"json"} success:^(GSNetRequest *netRequest) {
            [[[UIAlertView alloc] initWithTitle:self.titleArray[indexPath.row] message:@"请求成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        } failure:^(GSNetRequest *netRequest, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:self.titleArray[indexPath.row] message:@"请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }];
    }
    if (indexPath.row == 2) {
        GSNetRequest *netRequest = [[GSNetRequest alloc] init];
        netRequest.delegate = self;
        netRequest.tag = indexPath.row;
        [netRequest getRequestURLStr:@"http://api.meishi.cc/v2/lanmu.php?format=json"];

    }
    if (indexPath.row == 3) {
        GSNetRequest *netRequest = [[GSNetRequest alloc] init];
        netRequest.delegate = self;
        netRequest.tag = indexPath.row;
        [netRequest getRequestURLStr:@"http://api.meishi.cc/v2/lanmu.php?" parameters:@{@"format":@"json"}];
        
    }
    if (indexPath.row == 4) {
        GSNetRequest *netRequest = [[GSNetRequest alloc] init];
        [netRequest getRequestURLStr:@"http://api.meishi.cc/v2/lanmu.php?format=json" completionBlockWithSuccess:^(GSNetRequest *netRequest) {
            [[[UIAlertView alloc] initWithTitle:self.titleArray[indexPath.row] message:@"请求成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        } failure:^(GSNetRequest *netRequest, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:self.titleArray[indexPath.row] message:@"请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }];
        
    }
    if (indexPath.row == 5) {
        GSNetRequest *netRequest = [[GSNetRequest alloc] init];
        [netRequest getRequestURLStr:@"http://api.meishi.cc/v2/lanmu.php?" parameters:@{@"format":@"json"} completionBlockWithSuccess:^(GSNetRequest *netRequest) {
            [[[UIAlertView alloc] initWithTitle:self.titleArray[indexPath.row] message:@"请求成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        } failure:^(GSNetRequest *netRequest, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:self.titleArray[indexPath.row] message:@"请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }];
        
    }
}

# pragma mark --GSNetRequestDelegate
- (void)netRequestSuccess:(GSNetRequest *)netRequest{
    
    [[[UIAlertView alloc] initWithTitle:self.titleArray[netRequest.tag] message:@"请求成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}
- (void)netRequestIsFail:(GSNetRequest *)netRequest error:(NSError *)error{
    [[[UIAlertView alloc] initWithTitle:self.titleArray[netRequest.tag] message:@"请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}


# pragma mark =============
//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
