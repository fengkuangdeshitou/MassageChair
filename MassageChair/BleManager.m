//
//  BleManager.m
//  MassageChairSDK
//
//  Created by 王帅 on 2021/3/22.
//

#import "BleManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BleManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong) CBCentralManager * centralManager;
@property(nonatomic,strong) CBPeripheral * peripheral;
@property(nonatomic,strong) CBCharacteristic *characteristic;

@end

@implementation BleManager

NSString * const serviceUUID = @"D0611E78-BBB4-4591-A5F8-487910AE4366";

static BleManager *_manager = nil;

+ (instancetype)shareInstance{
    if (!_manager) {
        _manager = [[BleManager alloc] init];
        dispatch_queue_t centralQueue = dispatch_queue_create("centralQueue",DISPATCH_QUEUE_SERIAL);
        NSDictionary *options =@{CBCentralManagerOptionShowPowerAlertKey:@YES,CBCentralManagerOptionRestoreIdentifierKey:@"unique identifier"};
        _manager.centralManager = [[CBCentralManager alloc] initWithDelegate:_manager queue:centralQueue options:options];
    }
    return _manager;
}

- (void)startScanning{
    NSDictionary *option = @{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO],CBCentralManagerOptionShowPowerAlertKey:@YES};
    [self.centralManager scanForPeripheralsWithServices:nil options:option];
}

- (void)writeValueToBle:(NSDictionary *)vaue{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:vaue options:NSJSONWritingFragmentsAllowed error:nil];
    // 将指令写入蓝牙
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"未知状态");
            break;
        case CBManagerStateResetting:
            NSLog(@"重启状态");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"不支持");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"未授权");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙未开启");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"蓝牙启");
            [self startScanning];
            break;
        default:
            break;
    }
}

/// 发现外设回调
/// @param central central
/// @param peripheral 外设类
/// @param advertisementData 广播值 一般携带设备名，serviceUUIDs等信息
/// @param RSSI RSSI绝对值越大，表示信号越差，设备离的越远。如果想装换成百分比强度，（RSSI+100）/100
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"name=%@,%@",peripheral.name,RSSI);
    if([peripheral.name isEqualToString:@"iPad"]){
        [self.centralManager stopScan];
        //发起连接的命令
        [self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
        peripheral.delegate = self;
        self.peripheral = peripheral;
    }
}

/// 蓝牙于后台被杀掉时，重连之后会首先调用此方法，可以获取蓝牙恢复时的各种状态
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict{
    
}

/// 连接成功的回调
/// @param central 蓝牙管理
/// @param peripheral 外设
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //连接成功之后寻找服务，传nil会寻找所有服务
    [peripheral discoverServices:nil];
}

// 发现服务的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"serviceUUID:%@", service.UUID.UUIDString);
            if ([service.UUID.UUIDString isEqualToString:serviceUUID]) {
                //发现特定服务的特征值
                [service.peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

//发现characteristics，由发现服务调用（上一步），获取读和写的characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"===%@",characteristic.UUID.UUIDString);
        //有时读写的操作是由一个characteristic完成
//        if ([characteristic.UUID.UUIDString isEqualToString:@"2A24"]) {
            self.characteristic = characteristic;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
            NSData *data = [@"11" dataUsingEncoding:NSUTF8StringEncoding];
            // 将指令写入蓝牙
            [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//        }
//        else if ([characteristic.UUID.UUIDString isEqualToString:ST_CHARACTERISTIC_UUID_WRITE]) {
//            self.write = characteristic;
//        }
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

//数据接收
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if([characteristic.UUID.UUIDString isEqualToString:@"2A24"]){
        //获取订阅特征回复的数据
        NSData *value = characteristic.value;
        NSLog(@"蓝牙回复：%@",value);
//    }
}

#pragma mark - 中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    } else {
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        NSLog(@"%@", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

//是否写入成功的代理
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"===写入错误：%@",error);
    }else{
        NSLog(@"===写入成功");
    }
}

/// 连接失败的回调
/// @param central 蓝牙管理
/// @param peripheral 外设
/// @param error 错误
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

/// 连接断开
/// @param central 蓝牙管理
/// @param peripheral 外设
/// @param error 错误
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
}

@end
