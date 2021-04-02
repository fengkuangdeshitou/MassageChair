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

NSString * const  UUID_CONTROL_SERVICE =           @"00001530-0000-3512-2118-0009AF100700";
NSString * const  UUID_LISTEN_CHARACTERISTICS =    @"00001531-0000-3512-2118-0009AF100700";
NSString * const  UUID_CONTROL_CHARACTERISTICS =   @"00000014-0000-3512-2118-0009AF100700";

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

- (void)writeValueToBle:(NSString *)vaue{
    
    Byte byte[] = {0x5A,0x5A,0x81,0x02,0x02,0x01,0x01,0x0D};;
    NSData * data = [[NSData alloc] initWithBytes:byte length:8];
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
    if([peripheral.name isEqualToString:@"Mi Smart Band 5"]){
        [self.centralManager stopScan];
        //发起连接的命令
        [self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
        peripheral.delegate = self;
        self.peripheral = peripheral;
    }
}

/// 蓝牙于后台被杀掉时，重连之后会首先调用此方法，可以获取蓝牙恢复时的各种状态
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict{
    self.peripheral = [dict[@"kCBRestoredPeripherals"] firstObject];
    self.peripheral.delegate = self;
    [self.centralManager connectPeripheral:self.peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
    NSLog(@"连接数据=%@",self.peripheral);
}

/// 连接成功的回调
/// @param central 蓝牙管理
/// @param peripheral 外设
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    //连接成功之后寻找服务，传nil会寻找所有服务
    [peripheral discoverServices:nil];
}

/// 连接失败的回调
/// @param central 蓝牙管理
/// @param peripheral 外设
/// @param error 错误
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"连接失败%s",__func__);

}

/// 连接断开
/// @param central 蓝牙管理
/// @param peripheral 外设
/// @param error 错误
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"连接断开%s",__func__);

}

// 发现服务的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"serviceUUID:%@", service.UUID.UUIDString);
            if ([service.UUID.UUIDString isEqualToString:UUID_CONTROL_SERVICE]) {
                //发现特定服务的特征值
                [service.peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:UUID_CONTROL_SERVICE]] forService:service];
                break;
            }
        }
    }
}

//peripheral代理方法2
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error{
    //这个方法并不会被调用，而且如果不实现peripheral代理方法1会报下面的错误
//API MISUSE: Discovering services for peripheral while delegate is either nil or does not implement peripheral:didDiscoverServices:
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@",service);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@",service.UUID.UUIDString);
    }
}

//发现characteristics，由发现服务调用（上一步），获取读和写的characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"===%@",characteristic.UUID.UUIDString);
        //有时读写的操作是由一个characteristic完成
        if ([characteristic.UUID.UUIDString isEqualToString:UUID_LISTEN_CHARACTERISTICS]) {
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.characteristic = characteristic;
            [self writeValueToBle:@""];
        }
//        else if ([characteristic.UUID.UUIDString isEqualToString:UUID_CONTROL_CHARACTERISTICS]) {
//            self.write = characteristic;
//        }
//        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
}

//数据接收
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if([characteristic.UUID.UUIDString isEqualToString:@"2A24"]){
        //获取订阅特征回复的数据
        NSData *data = characteristic.value;
        NSString *response = [self valueStringWithResponse:data];
        NSLog(@"蓝牙回复：%@,%@",response,data);
//    }
}

#pragma mark - 中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    } else {
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        NSLog(@"value=%@", characteristic.value);
//        [self.centralManager cancelPeripheralConnection:peripheral];
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

#pragma mark 发送和接收数据解析相关，以下是针对我目前项目中蓝牙功能的封装，不一定适用其他项目
- (NSData *)command:(NSString *)hexCommand withOption:(NSString *)option{
    NSData *optionData = [option dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger totalLength = optionData.length + 5;
    NSString *hexOptionString = [self dataToHex:optionData];
    NSString *lengthString = [NSString stringWithFormat:@"%X",(int)totalLength];
    //最长只支持 255 长度的命令
    if (lengthString.length==1) {
        lengthString = [NSString stringWithFormat:@"0%@",lengthString];
    }
    NSString *hexCommandString = [NSString stringWithFormat:hexCommand,lengthString,hexOptionString];
    NSData *commandData = [self dataFromHexString:hexCommandString];
    return commandData;
}

- (NSData *)dataFromHexString:(NSString *)hexString {
    const char *chars = [hexString UTF8String];
    long i = 0, len = hexString.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

- (NSString *)dataToHex:(NSData *)data {
    NSUInteger i, len;
    unsigned char *buf, *bytes;
    
    len = data.length;
    bytes = (unsigned char*)data.bytes;
    buf = malloc(len*2);
    
    for (i=0; i<len; i++) {
        buf[i*2] = itoh((bytes[i] >> 4) & 0xF);
        buf[i*2+1] = itoh(bytes[i] & 0xF);
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buf
                                          length:len*2
                                        encoding:NSUTF8StringEncoding
                                    freeWhenDone:YES];
}

static inline char itoh(int i) {
    if (i > 9)
        return 'A' + (i - 10);
    return '0' + i;
}


/*
 *   把返回命令里的传递值拿出来
 */
- (NSString *)valueStringWithResponse:(NSData *)data {
    //NSData *ad = [NSData dataWithBytes:0x00 length:2];
    if (data.length <= 5) {
        return nil;
    }
    NSData *tailData = [data subdataWithRange:NSMakeRange(data.length-1, 1)];
    if ([tailData isEqualToData:[NSData dataWithBytes:"\0" length:1]]) {
        if (data.length > 6) {
            NSData *valueData = [data subdataWithRange:NSMakeRange(4, data.length-5)];
            NSString *valueString = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
            return valueString;
        }
    } else {
        if (data.length > 5) {
            NSData *valueData = [data subdataWithRange:NSMakeRange(4, data.length-4)];
            NSString *valueString = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
            return valueString;
        }
    }
    return nil;
}

@end
