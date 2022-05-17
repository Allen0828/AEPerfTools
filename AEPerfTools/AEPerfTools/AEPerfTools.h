//
//  AEPerfTools.h
//  AEPerfTools
//
//  Created by gw_pro on 2022/5/17.
//

#import <UIKit/UIKit.h>



@interface AEPerfTools : NSObject

+ (id)shared;

/* 基础信息*/
- (NSString*)getDeviceName;
- (NSString*)getDeviceModel;
- (NSString*)getDeviceLocalizedModel;
- (NSString*)getDeviceSystemName;
- (NSString*)getDeviceSystemVersion;
// UIDeviceOrientationUnknown, Portrait, PortraitUpsideDown, LandscapeLeft, LandscapeRight, FaceUp, FaceDown
- (UIDeviceOrientation)getDeviceOrientation;
- (NSString*)getDeviceUUID;
- (NSString *)getCountry;
- (NSString *)getLanguage;

/* 电池*/
// 范围 0-1 百分比
- (CGFloat)getBatteryLevel;
// UIDeviceBatteryStateUnknown, Unplugged, Charging, Full
// 调用此方法会打开电池状态监控
- (UIDeviceBatteryState)getBatteryState;


/* CPU*/
- (NSString*)getCPUName;
- (NSString*)getCPUType;
- (int)getCPUCoreNumber;
- (int)getCPUFrequencyMHZ;
- (double)getDeviceCPUUasge;
- (double)getAppCPUUasge;
// 每个内核的使用情况
- (NSArray<NSNumber*>*)getCPUs;

/* 内存 MB*/
- (double)getDeviceMemory;
- (double)getAppMemory:(BOOL)inPercent;
- (double)getFreeMemory:(BOOL)inPercent;
- (double)getUsedMemory:(BOOL)inPercent;
- (double)getActiveMemory:(BOOL)inPercent;
- (double)getInactiveMemory:(BOOL)inPercent;
- (double)getWiredMemory:(BOOL)inPercent;
- (double)getPurgableMemory:(BOOL)inPercent;


/* Disk GB*/
- (double)getDeviceDisk;
- (double)getUsedDisk:(BOOL)inPercent;
- (double)getFreeDisk:(BOOL)inPercent;


/* GPU MB*/ 
- (NSString*)getGPUName;
- (double)getAppGPU;

@end


