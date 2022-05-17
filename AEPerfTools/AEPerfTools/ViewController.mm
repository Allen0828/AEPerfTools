//
//  ViewController.m
//  AEPerfTools
//
//  Created by gw_pro on 2022/5/16.
//

#import "ViewController.h"
#include "AEPerfTools.h"

@interface ViewController ()

@property (nonatomic,strong) UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.showLabel.frame = CGRectMake(16, 40, [UIScreen mainScreen].bounds.size.width-32, [UIScreen mainScreen].bounds.size.height-80);
    [self.view addSubview:self.showLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self update];
    }];
}


- (void)update {
    AEPerfTools *shared = [AEPerfTools shared];
    
    NSString *msg = [NSString stringWithFormat:@"基本信息\nname=%@, model=%@, localizedModel=%@, systemname=%@, SystemVersion=%@, 设备朝向=%lu, uuid=%@, Country=%@, Language=%@ \n\n电池\n当前电量=%.2f, 电池状态=%lu \n\nCPU\nname=%@, type=%@, coreNum=%d, 主频率=%d, \n当前设备CPU总使用=%.2f%%, \napp使用cpu=%.2f%%, \ncpus=%@, \n\n内存\n设备总内存=%.2fMB, app使用内存=%.2fMB, 空闲内存=%.2fMB, 已使用内存=%.2fMB, 活跃内存=%.2fMB, 不活跃内存=%.2fMB \n\n磁盘\n设备总容量=%.2fGB, 已使用==%.2fGB, 未使用==%.2fGB\n\nGPU\nname=%@, 当前使用=%.2f%%",
                     [shared getDeviceName],
                     [shared getDeviceModel],
                     [shared getDeviceLocalizedModel],
                     [shared getDeviceSystemName],
                     [shared getDeviceSystemVersion],
                     [shared getDeviceOrientation],
                     [shared getDeviceUUID],
                     [shared getCountry],
                     [shared getLanguage],
                     
                     [shared getBatteryLevel],
                     [shared getBatteryState],
                     
                     [shared getCPUName],
                     [shared getCPUType],
                     [shared getCPUCoreNumber],
                     [shared getCPUFrequencyMHZ],
                     [shared getDeviceCPUUasge],
                     [shared getAppCPUUasge],
                     [shared getCPUs],
                     
                     [shared getDeviceMemory],
                     [shared getAppMemory:false],
                     [shared getFreeMemory:false],
                     [shared getUsedMemory:false],
                     [shared getActiveMemory:false],
                     [shared getInactiveMemory:false],
                     
                     [shared getDeviceDisk],
                     [shared getUsedDisk:false],
                     [shared getFreeDisk:false],
                     
                     [shared getGPUName],
                     [shared getAppGPU]
    ];

    
    self.showLabel.text = msg;
}

- (UILabel *)showLabel {
    if (_showLabel == nil) {
        _showLabel = [UILabel new];
        _showLabel.font = [UIFont systemFontOfSize:15];
        _showLabel.textColor = UIColor.blackColor;
        _showLabel.numberOfLines = 0;
    }
    return _showLabel;
}




@end

