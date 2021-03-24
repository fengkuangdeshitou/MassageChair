//
//  ViewController.m
//  MassageChair
//
//  Created by 王帅 on 2021/3/22.
//

#import "ViewController.h"
#import <MassageChairSDK/PanelViewController.h>
#import <CommonCrypto/CommonCrypto.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSString * appId = @"a0d9ba8e8a424431b2cd36d63bbe8955";
    NSString * bizId = @"1101999999";
    NSString * timestamps = @"1616581839725";
    NSString * body = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"data",@"MgMlbWS8n4dHLxHBT4f8K4lp6/5Pw/cPBrmd1ACROHDqTpiFhJR+3lnaOZgAWrfxAchKnGD+2NpGXmYUAW/WfM4rhHb284MAhaxeqkMpgTrdDmiB3O7a4obRjA=="];
    
    
    NSString * string = [NSString stringWithFormat:@"appId%@bizId%@timestamps%@%@",appId,bizId,timestamps,body];
    NSLog(@"string=%@",string);
    
    NSString * sign = [self sha256HashFor:string];
    NSLog(@"sign=%@",sign);
    
}

//SHA256加密
- (NSString*)sha256HashFor:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}


- (void)action{
    PanelViewController * panel = [[PanelViewController alloc] init];
    [self presentViewController:panel animated:YES completion:^{
            
    }];
}

@end
