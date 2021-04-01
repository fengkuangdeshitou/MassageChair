//
//  ViewController.m
//  MassageChair
//
//  Created by 王帅 on 2021/3/22.
//

#import "ViewController.h"
#import <MassageChairSDK/PanelViewController.h>
#import "NSData+CRC16.h"
#import "NSString+SwitchData.h"

@interface ViewController ()

@end

@implementation ViewController

// int转两个字节Byte
- (NSData *)dataFromShort:(short)value {
    Byte bytes[2] = {};
    for (int i = 0; i < 2; i++) {
        int offset = 16 - (i + 1) * 8;
        bytes[i] = (Byte) ((value >> offset) & 0xff);
    }
    NSData *data = [[NSData alloc] initWithBytes:bytes length:2];
    return data;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Byte byteData[8] = {0};
    byteData[0] = 0x51;
    byteData[1] = 0x81;
    NSLog(@"=====%x",byteData[0]);
    
    NSData *data1 = [NSData dataWithBytes:[self dataFromShort:81].bytes length:[self dataFromShort:81].length];

    NSLog(@"测试%@",data1);
    
    
    Byte byte[] = {0x5A,0x5A,0x81,0x02,0x02,0x0D};
    NSData * data = [[NSData alloc] initWithBytes:byte length:6];
    NSLog(@"data=%d",[data crc16:data len:0]);
    
    
    int jsonlen = 81;
    char *p_json = (char *)&jsonlen;
    char str_json[4] = {0};
    
    for(int i= 0 ;i < 4 ;i++)
    {
        str_json[i] = *p_json;
        p_json ++;
    }
    
    
    //十进制->十六进制
    Byte bytes[]={0xA6,0x27,0x0A};
    NSString *strIdL = [NSString stringWithFormat:@"%@",[[NSString alloc]initWithFormat:@"%02lx",(long)bytes[1]]];
    NSLog(@"stridl=%@",strIdL);
    
    //十六进制->十进制
    NSString *rechargeInfo = @"0x51";
    NSString *cardId2 = [rechargeInfo substringWithRange:NSMakeRange(2,2)];
    cardId2 = [NSString stringWithFormat:@"%ld",strtoul([cardId2 UTF8String],0,16)];
    NSLog(@"16进制:51->10:进制 %@",cardId2);
    
    NSLog(@"10进制:81->16进制:%@",[@"81" decimalToHex]);
    
    NSLog(@"16进制:51->10:进制 %@",[@"51" hexToDecimal]);
    
    NSLog(@"16进制转data:%@",[[@"81" decimalToHex] convertBytesStringToData]);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)action{
    PanelViewController * panel = [[PanelViewController alloc] init];
    [self presentViewController:panel animated:YES completion:^{
            
    }];
}

@end
