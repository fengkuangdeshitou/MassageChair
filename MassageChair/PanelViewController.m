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
@property(nonatomic,weak)IBOutlet UIView * rightView;
@property(nonatomic,weak)IBOutlet UIButton * timingButton;
@property(nonatomic,weak)IBOutlet UIButton * endButton;
@property(nonatomic,strong)ArcProgressView * arcProgressView;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger numberCount;

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
    
    self.leftView.transform = CGAffineTransformMakeRotation(-M_PI/4);
    self.rightView.transform = CGAffineTransformMakeRotation(M_PI/4);
    
    self.timingButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.timingButton.layer.borderWidth = 1;
    self.endButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.endButton.layer.borderWidth = 1;
    
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
    self.arcProgressView.time = [NSString stringWithFormat:@"%ld",self.numberCount];
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
