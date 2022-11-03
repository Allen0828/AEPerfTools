//
//  AEPerfTools.m
//  AEPerfTools
//
//  Created by allen0828 on 2022/5/17.
//


#import "AEPerfTools.h"
#import <MetalKit/MetalKit.h>
#include <sys/utsname.h>
#include <sys/sysctl.h>
#include <mach-o/arch.h>
#include <mach/mach.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>
#include <net/if.h>

#define MEM_PER_MB (1024 * 1024)

@interface AEPerfTools ()
{
    UIDevice *_device;
}


@end

@implementation AEPerfTools

+ (id)shared {
    static AEPerfTools *single = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        single = [[AEPerfTools alloc] init];
        [single config];
    });
    return single;
}
- (void)config {
    _device = [UIDevice currentDevice];
    _device.batteryMonitoringEnabled = true;
}

- (NSString*)getDeviceName {
    return _device.name;
}
- (NSString*)getDeviceModel {
    return _device.model;
}
- (NSString*)getDeviceLocalizedModel {
    return _device.localizedModel;
}
- (NSString*)getDeviceSystemName {
    return _device.systemName;
}
- (NSString*)getDeviceSystemVersion {
    return _device.systemVersion;
}
- (UIDeviceOrientation)getDeviceOrientation {
    return _device.orientation;
}
- (NSString*)getDeviceUUID {
    return _device.identifierForVendor.UUIDString;
}
- (NSString *)getCountry {
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    if (country == nil || country.length <= 0) {
        return nil;
    }
    return country;
}
- (NSString *)getLanguage {
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    if (language == nil || language.length <= 0) {
        return nil;
    }
    return language;
}
- (CGFloat)getScreenBrightness {
    CGFloat brightness = [UIScreen mainScreen].brightness;
    if (brightness < 0.0 || brightness > 1.0) {
        return -1;
    }
    return brightness;
}


- (CGFloat)getBatteryLevel {
    return _device.batteryLevel;
}
- (UIDeviceBatteryState)getBatteryState {
    return _device.batteryState;
}


- (NSString*)getCPUName {
    NSString *model = @"";
    if ([[NSProcessInfo processInfo].environment.allKeys containsObject:@"SIMULATOR_MODEL_IDENTIFIER"]) {
        model = [NSProcessInfo processInfo].environment[@"SIMULATOR_MODEL_IDENTIFIER"];
    } else {
        struct utsname systemInfo;
        uname(&systemInfo);
        model = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    // ipod
    if ([model isEqualToString:@"iPod7,1"]) return @"Apple A8";
    if ([model isEqualToString:@"iPod9,1"]) return @"Apple A10";
    // iphone
    if ([model isEqualToString:@"iPhone7,1"] || [model isEqualToString:@"iPhone7,2"]) return @"Apple A8";
    if ([model isEqualToString:@"iPhone8,1"] || [model isEqualToString:@"iPhone8,2"] || [model isEqualToString:@"iPhone8,4"]) return @"Apple A9";
    if ([model isEqualToString:@"iPhone9,1"] || [model isEqualToString:@"iPhone9,2"] || [model isEqualToString:@"iPhone9,3"] || [model isEqualToString:@"iPhone9,4"]) return @"Apple A10";
    if ([model isEqualToString:@"iPhone10,1"] || [model isEqualToString:@"iPhone10,2"] || [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,4"] || [model isEqualToString:@"iPhone10,5"] || [model isEqualToString:@"iPhone10,6"]) return @"Apple A11";
    if ([model isEqualToString:@"iPhone11,2"] || [model isEqualToString:@"iPhone11,4"] || [model isEqualToString:@"iPhone11,6"] || [model isEqualToString:@"iPhone11,8"]) return @"Apple A12";
    if ([model isEqualToString:@"iPhone12,1"] || [model isEqualToString:@"iPhone12,3"] || [model isEqualToString:@"iPhone12,5"] || [model isEqualToString:@"iPhone12,8"]) return @"Apple A13";
    if ([model isEqualToString:@"iPhone13,1"] || [model isEqualToString:@"iPhone13,2"] || [model isEqualToString:@"iPhone13,3"] || [model isEqualToString:@"iPhone13,4"]) return @"Apple A14";
    if ([model isEqualToString:@"iPhone14,2"] || [model isEqualToString:@"iPhone14,3"] || [model isEqualToString:@"iPhone14,4"] || [model isEqualToString:@"iPhone14,5"]) return @"Apple A15";
    //ipad
    if ([model isEqualToString:@"iPad5,1"] || [model isEqualToString:@"iPad5,2"]) return @"Apple A8";
    if ([model isEqualToString:@"iPad5,3"] || [model isEqualToString:@"iPad5,4"]) return @"Apple A8X";
    if ([model isEqualToString:@"iPad6,11"] || [model isEqualToString:@"iPad6,12"]) return @"Apple A9";
    if ([model isEqualToString:@"iPad6,3"] || [model isEqualToString:@"iPad6,4"] || [model isEqualToString:@"iPad6,7"] || [model isEqualToString:@"iPad6,8"]) return @"Apple A9X";
    if ([model isEqualToString:@"iPad7,1"] || [model isEqualToString:@"iPad7,2"] || [model isEqualToString:@"iPad7,3"] || [model isEqualToString:@"iPad7,4"]) return @"Apple A10X";
    if ([model isEqualToString:@"iPad8,1"] || [model isEqualToString:@"iPad8,2"] || [model isEqualToString:@"iPad8,3"] || [model isEqualToString:@"iPad8,4"]) return @"Apple A12X";
    if ([model isEqualToString:@"iPad8,5"] || [model isEqualToString:@"iPad8,6"] || [model isEqualToString:@"iPad8,7"] || [model isEqualToString:@"iPad8,8"] || [model isEqualToString:@"iPad8,9"] || [model isEqualToString:@"iPad8,10"] || [model isEqualToString:@"iPad8,11"] || [model isEqualToString:@"iPad8,12"]) return @"Apple A12Z";
    if ([model isEqualToString:@"iPad13,4"] || [model isEqualToString:@"iPad13,5"] || [model isEqualToString:@"iPad13,6"] || [model isEqualToString:@"iPad13,7"] || [model isEqualToString:@"iPad13,8"] || [model isEqualToString:@"iPad13,9"] || [model isEqualToString:@"iPad13,10"] || [model isEqualToString:@"iPad13,11"]) return @"Apple M1";
    return @"N/A";
}
- (NSString*)getCPUType {
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            return @"CPU_TYPE_ARM";
        case CPU_TYPE_ARM64:
            return @"CPU_TYPE_ARM64";
        case CPU_TYPE_X86:
            return @"CPU_TYPE_X86";
        case CPU_TYPE_X86_64:
            return @"CPU_TYPE_X86_64";
        default:
            return @"CPU_TYPE_Unkown";
    }
    return @"CPU_TYPE_Unkown";
}
- (int)getCPUCoreNumber {
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount = HOST_BASIC_INFO_COUNT;
    kern_return_t ret = host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    if (ret == KERN_SUCCESS) {
        return (int)hostInfo.max_cpus;
    }
    return 0;
}
- (int)getCPUFrequencyMHZ {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_CPU_FREQ};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (int)results;
}
- (double)getDeviceCPUUasge {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    return (user + nice + system) * 100.0 / total;
}
- (double)getAppCPUUasge {
    thread_array_t threads;
    mach_msg_type_number_t threadCount;
    if (task_threads(mach_task_self(), &threads, &threadCount) != KERN_SUCCESS) {
        return -1;
    }
    double usage = 0;
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t     threadInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info(threads[i], THREAD_BASIC_INFO, (thread_info_t) threadInfo, &threadInfoCount) != KERN_SUCCESS) {
            usage = -1;
            break;
        }
        auto info = (thread_basic_info_t) threadInfo;
        if ((info->flags & TH_FLAGS_IDLE) == 0) {
            usage += double(info->cpu_usage) / TH_USAGE_SCALE;
        }
    }
    usage = usage * 100;
    vm_deallocate(mach_task_self(), (vm_offset_t) threads, threadCount * sizeof(thread_t));
    return usage;
}
- (NSArray<NSNumber*>*)getCPUs {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock* _cpuUsageLock;

    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;

    _cpuUsageLock = [[NSLock alloc] init];
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS)
    {
        [_cpuUsageLock lock];
        NSMutableArray* processorInfo = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i)
        {
            Float32 _inUse, _total;
            if (_prevCPUInfo)
            {
                _inUse = ((_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]) + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM]) + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]));
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            }
            else
            {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [processorInfo addObject:@(_inUse / _total)];
        }

        [_cpuUsageLock unlock];
        if (_cpuInfo)
        {
            size_t cpuInfoSize = vm_size_t(sizeof(integer_t)) * vm_size_t(_numCPUs);
            vm_deallocate(mach_task_self(), (vm_address_t)_cpuInfo, cpuInfoSize);
        }
        return processorInfo;
    }
    else
    {
        return @[];
    }
}


- (double)getDeviceMemory {
    double all = [[NSProcessInfo processInfo] physicalMemory];
    return all / MEM_PER_MB;
}
- (double)getAppMemory:(BOOL)inPercent {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsage = (int64_t)vmInfo.phys_footprint / MEM_PER_MB;
        if (inPercent) {
            double fm = [self getDeviceMemory];
            return double((memoryUsage * 100) / fm);
        }
        return double(memoryUsage);
    } else {
        return 0;
    }
}
- (double)getFreeMemory:(BOOL)inPercent {
    double mem = 0.00;
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return -1;
    }
    if (inPercent) {
        double fm = [self getDeviceMemory];
        double am = ((vm_page_size * vmStats.free_count) / MEM_PER_MB);
        mem = (am * 100) / fm;
    } else {
        mem = ((vm_page_size * vmStats.free_count) / MEM_PER_MB);
    }
    return mem;
}
- (double)getUsedMemory:(BOOL)inPercent {
    double mem = 0.00;
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return -1;
    }
    natural_t usedMemory = (natural_t)((vm_stat.active_count +
                            vm_stat.inactive_count +
                            vm_stat.wire_count) * pagesize);
    if (inPercent) {
        double um = usedMemory / MEM_PER_MB;
        double am = [self getDeviceMemory];
        mem = (um * 100) / am;
    } else {
        mem = usedMemory / MEM_PER_MB;
    }
    return mem;
}
- (double)getActiveMemory:(BOOL)inPercent {
    double mem = 0.00;
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return -1;
    }
    if (inPercent) {
        double fm = [self getDeviceMemory];
        double am = (vm_stat.active_count * pagesize) / MEM_PER_MB;
        mem = (am * 100) / fm;
    } else {
        mem = (vm_stat.active_count * pagesize) / MEM_PER_MB;
    }
    return mem;
}
- (double)getInactiveMemory:(BOOL)inPercent {
    double mem = 0.00;
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return -1;
    }
    if (inPercent) {
        double fm = [self getDeviceMemory];
        double am = (vm_stat.inactive_count * pagesize) / MEM_PER_MB;
        mem = (am * 100) / fm;
    } else {
        mem = (vm_stat.inactive_count * pagesize) / MEM_PER_MB;
    }
    return mem;
}
- (double)getWiredMemory:(BOOL)inPercent {
    double mem = 0.00;
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return -1;
    }
    if (inPercent) {
        double fm = [self getDeviceMemory];
        double am = (vm_stat.wire_count * pagesize) / MEM_PER_MB;
        mem = (am * 100) / fm;
    } else {
        mem = ((vm_stat.wire_count * pagesize) / 1024.0) / 1024.0;
    }
    return mem;
}
- (double)getPurgableMemory:(BOOL)inPercent {
    double mem = 0.00;
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return -1;
    }
    if (inPercent) {
        double fm = [self getDeviceMemory];
        double am = (vm_stat.purgeable_count * pagesize) / MEM_PER_MB;
        mem = (am * 100) / fm;
    } else {
        mem = (vm_stat.purgeable_count * pagesize) / MEM_PER_MB;
    }
    return mem;
}


- (double)getDeviceDisk {
    double diskSpace = 0.0;
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error == nil) {
        diskSpace = [[fileAttributes objectForKey:NSFileSystemSize] doubleValue];
    } else {
        return -1;
    }
    if (diskSpace <= 0) {
        return -1;
    }
    return diskSpace / 1024 / 1024 / 1024;
}
- (double)getUsedDisk:(BOOL)inPercent {
    double uds;
    double tds = [self getDeviceDisk];
    double fds = [self getFreeDisk:false];
    if (tds <= 0 || fds <= 0) {
        return -1;
    }
    uds = tds - fds;
    if (inPercent) {
        uds = (uds * 100) / tds;
    }
    return uds;
}
- (double)getFreeDisk:(BOOL)inPercent {
    double fds = 0.0;
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error == nil) {
        fds = [[fileAttributes objectForKey:NSFileSystemFreeSize] doubleValue] / 1024 / 1024 / 1024;
    } else {
        return -1;
    }
    if (fds <= 0) {
        return -1;
    }
    if (inPercent) {
        fds = (fds * 100) / [self getDeviceDisk];
    }
    return fds;
}

- (NSString*)getGPUName {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if(!device) {
        return nil;
    }
    return device.name;
}
- (double)getAppGPUUasge {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if(!device) {
        return 0;
    }
    return double(device.currentAllocatedSize / MEM_PER_MB);
}


- (BOOL)connectedToWiFi {
    NSString *wiFiAddress = [self getWiFiIPAddress];
    if (wiFiAddress == nil || wiFiAddress.length <= 0) {
        return false;
    }
    return true;
}
- (BOOL)connectedToCellNetwork {
    NSString *cellAddress = [self getCellIPAddress];
    if (cellAddress == nil || cellAddress.length <= 0) {
        return false;
    }
    return true;
}
- (NSString*)getCurrentIPAddress {
    if ([self connectedToWiFi]) {
        return [self getWiFiIPAddress];
    }else if ([self connectedToCellNetwork]) {
        return [self getCellIPAddress];
    }
    return nil;
}
- (NSString*)getExternalIPAddress {
    if (![self connectedToCellNetwork] && ![self connectedToWiFi]) {
        return nil;
    }
    NSError *error = nil;
    NSString *externalIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://icanhazip.com/"] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        externalIP = [externalIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (externalIP == nil || externalIP.length <= 0) {
            return nil;
        }
        return externalIP;
    }
    return nil;
}


- (NSString*)getCellIPAddress {
    NSString *ipAddress;
    struct ifaddrs *interfaces;
    struct ifaddrs *temp;
    struct sockaddr_in *s4;
    char buf[64];
    
    if (!getifaddrs(&interfaces)) {
        temp = interfaces;
        while(temp != NULL) {
            if(temp->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    s4 = (struct sockaddr_in *)temp->ifa_addr;
                    if (inet_ntop(temp->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) == NULL) {
                        ipAddress = nil;
                    } else {
                        ipAddress = [NSString stringWithUTF8String:buf];
                    }
                }
            }
            temp = temp->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    if (ipAddress == nil || ipAddress.length <= 0) {
        return nil;
    }
    return ipAddress;
}


- (NSString*)getWiFiIPAddress {
    NSString *ipAddress;
    struct ifaddrs *interfaces;
    struct ifaddrs *temp;
    int Status = 0;
    Status = getifaddrs(&interfaces);
    if (Status == 0) {
        temp = interfaces;
        while(temp != NULL) {
            if(temp->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"en0"]) {
                    ipAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp->ifa_addr)->sin_addr)];
                }
            }
            temp = temp->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    if (ipAddress == nil || ipAddress.length <= 0) {
        return nil;
    }
    return ipAddress;
}
- (NSString*)getWiFiIPv6Address {
    NSString *ipAddress;
    struct ifaddrs *interfaces;
    struct ifaddrs *temp;
    int status = 0;
    status = getifaddrs(&interfaces);
    
    if (status == 0) {
        temp = interfaces;
        while(temp != NULL) {
            if(temp->ifa_addr->sa_family == AF_INET6) {
                if([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"en0"]) {
                    struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)temp->ifa_addr;
                    char buf[INET6_ADDRSTRLEN];
                    if (inet_ntop(AF_INET6, (void *)&(addr6->sin6_addr), buf, sizeof(buf)) == NULL) {
                        ipAddress = nil;
                    } else {
                        ipAddress = [NSString stringWithUTF8String:buf];
                    }
                }
            }
            temp = temp->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    if (ipAddress == nil || ipAddress.length <= 0) {
        return nil;
    }
    return ipAddress;
}
- (NSString*)getWiFiNetmaskAddress {
    struct ifreq afr;
    strncpy(afr.ifr_name, [@"en0" UTF8String], IFNAMSIZ-1);
    int afd = socket(AF_INET, SOCK_DGRAM, 0);
    if (afd == -1) {
        return nil;
    }
    if (ioctl(afd, SIOCGIFNETMASK, &afr) == -1) {
        close(afd);
        return nil;
    }
    close(afd);
    
    char *netstring = inet_ntoa(((struct sockaddr_in *)&afr.ifr_addr)->sin_addr);
    NSString *netmask = [NSString stringWithUTF8String:netstring];
    if (netmask == nil || netmask.length <= 0) {
        return nil;
    }
    return netmask;
}
- (NSString*)getWiFiBroadcastAddress {
    NSString *ipAddress = [self getWiFiIPAddress];
    NSString *nmAddress = [self getWiFiNetmaskAddress];
    
    if (ipAddress == nil || ipAddress.length <= 0) {
        return nil;
    }
    if (nmAddress == nil || nmAddress.length <= 0) {
        return nil;
    }
    NSArray *ipCheck = [ipAddress componentsSeparatedByString:@"."];
    NSArray *nmCheck = [nmAddress componentsSeparatedByString:@"."];
    if (ipCheck.count != 4 || nmCheck.count != 4) {
        return nil;
    }
    NSUInteger ip = 0;
    NSUInteger nm = 0;
    NSUInteger cs = 24;
    
    for (NSUInteger i = 0; i < 4; i++, cs -= 8) {
        ip |= [[ipCheck objectAtIndex:i] intValue] << cs;
        nm |= [[nmCheck objectAtIndex:i] intValue] << cs;
    }
    NSUInteger ba = ~nm | ip;
    NSString *broadcastAddress = [NSString stringWithFormat:@"%lu.%lu.%lu.%lu", (long)(ba & 0xFF000000) >> 24, (long)(ba & 0x00FF0000) >> 16, (long)(ba & 0x0000FF00) >> 8, (long)(ba & 0x000000FF)];
    
    if (broadcastAddress == nil || broadcastAddress.length <= 0) {
        return nil;
    }
    return broadcastAddress;
}


@end



// #define CTL_UNSPEC      0               /* unused */
// #define CTL_KERN        1               /* "high kernel": proc, limits */
// #define CTL_VM          2               /* virtual memory */
// #define CTL_VFS         3               /* file system, mount type is next */
// #define CTL_NET         4               /* network, see socket.h */
// #define CTL_DEBUG       5               /* debugging parameters */
// #define CTL_HW          6               /* generic cpu/io */
// #define CTL_MACHDEP     7               /* machine dependent */
// #define CTL_USER        8               /* user-level */
// #define CTL_MAXID       9               /* number of valid top-level ids */
//
// #define HW_MACHINE       1              /* string: machine class (deprecated: use HW_PRODUCT) */
// #define HW_MODEL         2              /* string: specific machine model (deprecated: use HW_TARGET) */
// #define HW_NCPU          3              /* int: number of cpus */
// #define HW_BYTEORDER     4              /* int: machine byte order */
// #define HW_PHYSMEM       5              /* int: total memory */
// #define HW_USERMEM       6              /* int: non-kernel memory */
// #define HW_PAGESIZE      7              /* int: software page size */
// #define HW_DISKNAMES     8              /* strings: disk drive names */
// #define HW_DISKSTATS     9              /* struct: diskstats[] */
// #define HW_EPOCH        10              /* int: 0 for Legacy, else NewWorld */
// #define HW_FLOATINGPT   11              /* int: has HW floating point? */
// #define HW_MACHINE_ARCH 12              /* string: machine architecture */
// #define HW_VECTORUNIT   13              /* int: has HW vector unit? */
// #define HW_BUS_FREQ     14              /* int: Bus Frequency */
// #define HW_CPU_FREQ     15              /* int: CPU Frequency */
// #define HW_CACHELINE    16              /* int: Cache Line Size in Bytes */
// #define HW_L1ICACHESIZE 17              /* int: L1 I Cache Size in Bytes */
// #define HW_L1DCACHESIZE 18              /* int: L1 D Cache Size in Bytes */
// #define HW_L2SETTINGS   19              /* int: L2 Cache Settings */
// #define HW_L2CACHESIZE  20              /* int: L2 Cache Size in Bytes */
// #define HW_L3SETTINGS   21              /* int: L3 Cache Settings */
// #define HW_L3CACHESIZE  22              /* int: L3 Cache Size in Bytes */
// #define HW_TB_FREQ      23              /* int: Bus Frequency */
// #define HW_MEMSIZE      24              /* uint64_t: physical ram size */
// #define HW_AVAILCPU     25              /* int: number of available CPUs */
// #define HW_TARGET       26              /* string: model identifier */
// #define HW_PRODUCT      27              /* string: product identifier */
// #define HW_MAXID        28              /* number of valid hw ids */
 

