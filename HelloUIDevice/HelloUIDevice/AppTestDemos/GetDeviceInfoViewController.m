//
//  GetDeviceInfoViewController.m
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetDeviceInfoViewController.h"
#import "WCDeviceTool.h"
#import "WCMacroTool.h"

#define kTitle      @"title"
#define kSubtitle   @"subtitle"

@interface GetDeviceInfoViewController ()
@property (nonatomic, strong) NSArray<NSArray *> *sectionListData;
@property (nonatomic, strong) NSArray<NSString *> *sectionTitles;
@end

@implementation GetDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sectionTitles = @[
        @"Model",
        @"Processor",
        @"Memory",
        @"Disk",
        @"Identifier",
        @"Screen",
        @"Bettery",
        @"Network",
    ];
    
    _sectionListData = @[
        @[
            @{ kTitle: [WCDeviceTool deviceName], kSubtitle: @"device name" },
            @{ kTitle: [WCDeviceTool deviceModel], kSubtitle: @"device model" },
            @{ kTitle: [WCDeviceTool deviceLocalizedModel], kSubtitle: @"device localized model" },
            @{ kTitle: [WCDeviceTool deviceDetailedModel], kSubtitle: @"device detailed model" },
            @{ kTitle: [WCDeviceTool deviceModelPrettyPrinted:NO], kSubtitle: @"device model not pretty printed" },
            @{ kTitle: [WCDeviceTool deviceModelPrettyPrinted:YES], kSubtitle: @"device model pretty printed" },
            @{ kTitle: [WCDeviceTool devicePlatformType], kSubtitle: @"device platform" },
        ],
        @[
            @{ kTitle: [@([WCDeviceTool deviceProcessorNumber]) stringValue], kSubtitle: @"number of processor" },
            @{ kTitle: [@([WCDeviceTool deviceProcessorActiveNumber]) stringValue], kSubtitle: @"number of active processor" },
            @{ kTitle: [@([WCDeviceTool deviceProcessorFrequency]) stringValue], kSubtitle: @"processor frequency" },
        ],
        @[
            @{ kTitle: [@([WCDeviceTool deviceRAMSize]) stringValue], kSubtitle: @"RAM size" },
            @{ kTitle: [NSByteCountFormatter stringFromByteCount:[WCDeviceTool deviceTotalMemorySize] countStyle:NSByteCountFormatterCountStyleMemory], kSubtitle: @"total memory size" },
        ],
        @[
            @{ kTitle: [NSByteCountFormatter stringFromByteCount:[WCDeviceTool deviceDiskTotalSize] countStyle:NSByteCountFormatterCountStyleFile], kSubtitle: @"total disk size" },
            @{ kTitle: [NSByteCountFormatter stringFromByteCount:[WCDeviceTool deviceDiskFreeSize] countStyle:NSByteCountFormatterCountStyleFile], kSubtitle: @"total free disk size" },
            @{ kTitle: [NSByteCountFormatter stringFromByteCount:[WCDeviceTool deviceDiskUsedSize] countStyle:NSByteCountFormatterCountStyleFile], kSubtitle: @"total used disk size" },
        ],
        @[
            @{ kTitle: [WCDeviceTool deviceIdentifierForVendor], kSubtitle: @"identifierForVendor" },
        ],
        @[
            @{ kTitle: NSStringFromCGSize([WCDeviceTool deviceScreenSize]), kSubtitle: @"screen size by dp" },
            @{ kTitle: NSStringFromCGSize([WCDeviceTool deviceScreenSizeInPixel]), kSubtitle: @"screen size by px" },
            @{ kTitle: [@([WCDeviceTool deviceScreenScale]) stringValue], kSubtitle: @"screen scale" },
            @{ kTitle: [@([WCDeviceTool deviceScreenBrightness]) stringValue], kSubtitle: @"screen brightness" },
        ],
        @[
            @{ kTitle: STR_OF_BOOL([WCDeviceTool deviceBatteryMoniteringEnabled]), kSubtitle: @"battery monitor enabled" },
            @{ kTitle: [WCDeviceTool deviceBatteryState], kSubtitle: @"battery state" },
            @{ kTitle: [WCDeviceTool deviceBatteryLevel], kSubtitle: @"battery level" },
        ],
        @[
            @{ kTitle: STR_OF_BOOL([WCDeviceTool deviceWiFiEnabled]), kSubtitle: @"WiFi enabled" },
            @{ kTitle: [WCDeviceTool deviceWiFiAddress], kSubtitle: @"WiFi address" },
            @{ kTitle: [WCDeviceTool deviceWiFiIPv6Address], kSubtitle: @"WiFi IPv6 address" },
        ]
    ];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionListData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionListData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *dict = self.sectionListData[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[kTitle];
    cell.detailTextLabel.text = dict[kSubtitle];
    
    return cell;
}

@end
