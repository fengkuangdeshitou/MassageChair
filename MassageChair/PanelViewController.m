//
//  PanelViewController.m
//  MassageChairSDK
//
//  Created by maiyou on 2021/3/23.
//

#import "PanelViewController.h"
#import "ArcProgressView.h"
#import "BleManager.h"

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

@property(nonatomic,weak)IBOutlet UIView * leftDividerView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * leftDividerViewLeftConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * leftDividerViewBottomConstraint;

@property(nonatomic,weak)IBOutlet UIView * rightDividerView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * rightDividerViewRightConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * rightDividerViewBottompConstraint;

@property(nonatomic,weak)IBOutlet UIButton * timingButton;
@property(nonatomic,weak)IBOutlet UIButton * endButton;
@property(nonatomic,strong)ArcProgressView * arcProgressView;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger numberCount;

@property(nonatomic,weak)IBOutlet UILabel * directionLabel;
@property(nonatomic,weak)IBOutlet UILabel * speedLabel;
@property(nonatomic,weak)IBOutlet UILabel * temperatureLabel;
@property(nonatomic,weak)IBOutlet UILabel * modelLabel;

@property(nonatomic,assign)NSInteger timeFlag;
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
    
    self.numberCount = 20*60;
    self.arcProgressView.time = @"20:00";
    
    CGFloat radius = self.arcProgressView.bounds.size.width/2;
    
    self.leftView.transform = CGAffineTransformMakeRotation(-M_PI/4);
    self.leftViewLeftConstraint.constant = radius - radius/sqrtf(2)-6;
    self.leftViewTopConstraint.constant = radius - radius/sqrtf(2)-18;
    
    self.rightView.transform = CGAffineTransformMakeRotation(M_PI/4);
    self.rightViewRightConstraint.constant = radius - radius/sqrtf(2)-6;
    self.rightViewTopConstraint.constant = radius - radius/sqrtf(2)-18;
    
    self.leftDividerView.transform = CGAffineTransformMakeRotation(M_PI*53/40);
    self.leftDividerViewLeftConstraint.constant = radius - radius/sqrtf(2)-20;
    self.leftDividerViewBottomConstraint.constant = radius - radius/sqrtf(2);
    
    self.rightDividerView.transform = CGAffineTransformMakeRotation(-M_PI*53/40);
    self.rightDividerViewRightConstraint.constant = radius - radius/sqrtf(2)-20;
    self.rightDividerViewBottompConstraint.constant = radius - radius/sqrtf(2);
    
    self.timingButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.timingButton.layer.borderWidth = 1;
    self.endButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.endButton.layer.borderWidth = 1;
    
    self.directionFlag = 0;
    
}

- (IBAction)startCountdown:(id)sender{
    switch (self.timeFlag) {
        case 0:
            self.numberCount = 15*60;
            self.timeFlag = 1;
            self.arcProgressView.progress = 0.32;
            break;
        case 1:
            self.numberCount = 10*60;
            self.timeFlag = 2;
            self.arcProgressView.progress = 0.68;
            break;
        case 2:
            self.numberCount = 20*60;
            self.timeFlag = 0;
            self.arcProgressView.progress = 0;
            break;
        default:
            break;
    }
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void)handleTimer {
    self.numberCount--;
    if (self.numberCount == 0) {
        self.numberCount = 20*60;
        [self.timer invalidate];
    }

    CGFloat progress = 0;
    if (self.timeFlag == 0) {
        progress = (CGFloat)1/(20*60);
    }else if(self.timeFlag == 1){
        progress = 0.68/(20*60);
    }else{
        progress = 0.32/(10*60);
    }
    self.arcProgressView.progress += progress;
    self.arcProgressView.time = [self dateFormSeconds:self.numberCount];
}

- (NSString *)dateFormSeconds:(NSInteger)totalSeconds{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"mm:ss";
    return [fmt stringFromDate:date];
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
    [self.mamager writeValueToBle:@""];
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
            temperatureString = @"高温";
            self.temperatureFlag = 1;
            break;
        case 1:
            temperatureString = @"关闭";
            self.temperatureFlag = 2;
            break;
        case 2:
            temperatureString = @"低温";
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
            modelString = @"智能2";
            self.modelFlag = 1;
            break;
        case 1:
            modelString = @"智能3";
            self.modelFlag = 2;
            break;
        case 2:
            modelString = @"智能1";
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
