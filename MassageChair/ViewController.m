//
//  ViewController.m
//  MassageChair
//
//  Created by 王帅 on 2021/3/22.
//

#import "ViewController.h"
#import <MassageChairSDK/PanelViewController.h>

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
    
    
    
}

//SHA256加密
//+ (NSString*)sha256HashFor:(NSString*)input{
//    const char* str = [input UTF8String];
//    unsigned char result[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256(str, (CC_LONG)strlen(str), result);
//
//    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
//    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
//    {
//        [ret appendFormat:@"%02x",result[i]];
//    }
//    ret = (NSMutableString *)[ret uppercaseString];
//    return ret;
//}


- (void)action{
    PanelViewController * panel = [[PanelViewController alloc] init];
    [self presentViewController:panel animated:YES completion:^{
            
    }];
}

@end
