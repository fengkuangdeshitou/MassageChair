//
//  PanelViewController.m
//  MassageChairSDK
//
//  Created by maiyou on 2021/3/23.
//

#import "PanelViewController.h"
#import "ArcProgressView.h"
#import "BleManager.h"

@interface PanelViewController ()

@property(nonatomic,strong)BleManager * mamager;
@property(nonatomic,weak)IBOutlet UIImageView * bleStatusImageView;
@property(nonatomic,weak)IBOutlet UILabel * bleStatusLabel;
@property(nonatomic,weak)IBOutlet UISwitch * voiceSwitch;
@property(nonatomic,strong)ArcProgressView * arcProgressView;

@end

@implementation PanelViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSBundle * bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MassageChairBundle.bundle"]];
        self = [super initWithNibName:NSStringFromClass([self class]) bundle:bundle];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mamager = [BleManager shareInstance];
    self.arcProgressView = [[ArcProgressView alloc] initWithFrame:CGRectMake(30, 100, 300, 300)];
    [self.view addSubview:self.arcProgressView];
    
//    __block CGFloat progress = 0.01;
//    [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        progress += 0.01;
//        self.arcProgressView.progress = progress;
//        NSLog(@"===%f",self.arcProgressView.progress);
//    }];
    
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
