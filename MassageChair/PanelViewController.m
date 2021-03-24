//
//  PanelViewController.m
//  MassageChairSDK
//
//  Created by maiyou on 2021/3/23.
//

#import "PanelViewController.h"
#import "ArcProgressView.h"
#import "BleManager.h"

#define TIMECOUNT 60
#define K_Width UIScreen.mainScreen.bounds.size.width
#define K_Height UIScreen.mainScreen.bounds.size.height

@interface PanelViewController ()

@property(nonatomic,strong)BleManager * mamager;
@property(nonatomic,weak)IBOutlet UIImageView * bleStatusImageView;
@property(nonatomic,weak)IBOutlet UILabel * bleStatusLabel;
@property(nonatomic,weak)IBOutlet UISwitch * voiceSwitch;
@property(nonatomic,weak)IBOutlet UIView * progressBackgroundView;
@property(nonatomic,weak)IBOutlet UIView * leftView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * leftViewLeftConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * leftViewTopConstraint;

@property(nonatomic,weak)IBOutlet UIView * rightView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * rightViewRightConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * rightViewTopConstraint;
@property(nonatomic,weak)IBOutlet UIButton * timingButton;
@property(nonatomic,weak)IBOutlet UIButton * endButton;
@property(nonatomic,strong)ArcProgressView * arcProgressView;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger numberCount;

@property(nonatomic,weak)IBOutlet UILabel * directionLabel;
@property(nonatomic,weak)IBOutlet UILabel * speedLabel;
@property(nonatomic,weak)IBOutlet UILabel * temperatureLabel;
@property(nonatomic,weak)IBOutlet UILabel * modelLabel;

@property(nonatomic,assign)NSInteger directionFlag;
@property(nonatomic,assign)NSInteger speedFlag;
@property(nonatomic,assign)NSInteger temperatureFlag;
@property(nonatomic,assign)NSInteger modelFlag;

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
    self.arcProgressView = [[ArcProgressView alloc] initWithFrame:CGRectMake(0, 0, K_Width-44*2, K_Width-44*2)];
    [self.progressBackgroundView addSubview:self.arcProgressView];
    
    self.numberCount = TIMECOUNT;
    self.arcProgressView.time = @"10:00";
    
    CGFloat radius = self.arcProgressView.bounds.size.width/2;
    self.leftView.transform = CGAffineTransformMakeRotation(-M_PI/4);
    self.leftViewLeftConstraint.constant = radius - radius/sqrtf(2)-6;
    self.leftViewTopConstraint.constant = radius - radius/sqrtf(2)-18;
    self.rightView.transform = CGAffineTransformMakeRotation(M_PI/4);
    self.rightViewRightConstraint.constant = radius - radius/sqrtf(2)-6;
    self.rightViewTopConstraint.constant = radius - radius/sqrtf(2)-18;
    
    self.timingButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.timingButton.layer.borderWidth = 1;
    self.endButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.endButton.layer.borderWidth = 1;
    
    self.directionFlag = 0;
    
}

- (IBAction)startCountdown:(id)sender{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void)handleTimer {
    self.numberCount--;
    if (self.numberCount == 0) {
        self.timingButton.userInteractionEnabled = YES;
        self.numberCount = TIMECOUNT;
        [self.timer invalidate];
    } else {
        self.timingButton.userInteractionEnabled = NO;
    }
    
    CGFloat progress = (CGFloat)1/TIMECOUNT;
    self.arcProgressView.progress += progress;
//    self.arcProgressView.time = [NSString stringWithFormat:@"%ld",self.numberCount];
}

/// 方向切换
/// @param sender 按钮
- (IBAction)directionClickAction:(UIButton *)sender{
    NSString * directionString = nil;
    switch (self.directionFlag) {
        case 0:
            directionString = @"反向";
            self.directionFlag = 1;
            break;
        case 1:
            directionString = @"交替";
            self.directionFlag = 2;
            break;
        case 2:
            directionString = @"正向";
            self.directionFlag = 0;
            break;
        default:
            break;
    }
    self.directionLabel.text = directionString;
}

/// 速度切换
/// @param sender 按钮
- (IBAction)speedClickAction:(UIButton *)sender{
    NSString * speedString = nil;
    switch (self.speedFlag) {
        case 0:
            speedString = @"中速";
            self.speedFlag = 1;
            break;
        case 1:
            speedString = @"快速";
            self.speedFlag = 2;
            break;
        case 2:
            speedString = @"慢速";
            self.speedFlag = 0;
            break;
        default:
            break;
    }
    self.speedLabel.text = speedString;
}

/// 温度切换
/// @param sender 按钮
- (IBAction)temperatureClickAction:(UIButton *)sender{
    NSString * temperatureString = nil;
    switch (self.temperatureFlag) {
        case 0:
            temperatureString = @"中速";
            self.temperatureFlag = 1;
            break;
        case 1:
            temperatureString = @"快速";
            self.temperatureFlag = 2;
            break;
        case 2:
            temperatureString = @"慢速";
            self.temperatureFlag = 0;
            break;
        default:
            break;
    }
    self.temperatureLabel.text = temperatureString;
}

/// 模式切换
/// @param sender 按钮
- (IBAction)modelClickAction:(UIButton *)sender{
    NSString * modelString = nil;
    switch (self.modelFlag) {
        case 0:
            modelString = @"中速";
            self.modelFlag = 1;
            break;
        case 1:
            modelString = @"快速";
            self.modelFlag = 2;
            break;
        case 2:
            modelString = @"慢速";
            self.modelFlag = 0;
            break;
        default:
            break;
    }
    self.modelLabel.text = modelString;
}

- (IBAction)endCountDown:(id)sender{
    [self.timer invalidate];
    self.timingButton.userInteractionEnabled = YES;
    self.arcProgressView.progress = 0;
    self.arcProgressView.time = @"00:00";
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
