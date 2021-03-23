//
//  ArcProgressView.m
//  MassageChairSDK
//
//  Created by maiyou on 2021/3/23.
//

#import "ArcProgressView.h"

@interface ArcProgressView ()

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIColor * progressColor;
@property(nonatomic,strong)UIColor * progressBackgroundColor;
@property(nonatomic,assign)CGFloat lineWidth;

@end

@implementation ArcProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineWidth = 10;
        self.progressBackgroundColor = [UIColor grayColor];
        self.progressColor = [UIColor orangeColor];
        self.backgroundColor = UIColor.clearColor;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 35, frame.size.width-70, (frame.size.width-70)*380/480)];
        self.imageView.image = [UIImage imageNamed:@"img_jsback"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.textColor = UIColor.whiteColor;
        self.timeLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightMedium];
        self.timeLabel.text = @"00:00";
        self.timeLabel.textAlignment = 1;
        [self.timeLabel sizeToFit];
        [self addSubview:self.timeLabel];
        self.timeLabel.center = CGPointMake(self.center.x, self.center.y-20);
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor = UIColor.groupTableViewBackgroundColor;
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        titleLabel.text = @"TIME";
        titleLabel.textAlignment = 1;
        [self addSubview:titleLabel];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(self.center.x, self.center.y-55);
        
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textColor = UIColor.whiteColor;
        textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        textLabel.text = @"剩余时间";
        textLabel.textAlignment = 1;
        [self addSubview:textLabel];
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(self.center.x, self.center.y+20);
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setTime:(NSString *)time{
    _time = time;
    self.timeLabel.text = time;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIBezierPath * backgroundPath = [UIBezierPath bezierPath];
    [backgroundPath addArcWithCenter:center radius:rect.size.width/2-self.lineWidth/2 startAngle:M_PI-M_PI/5 endAngle:M_PI/5 clockwise:YES];
    backgroundPath.lineWidth = self.lineWidth;
    [self.progressColor setStroke];
    [backgroundPath stroke];
    
    UIBezierPath * strokePath = [UIBezierPath bezierPath];
    strokePath.lineWidth = self.lineWidth;
    [self.progressBackgroundColor setStroke];
    strokePath.lineCapStyle = kCGLineCapButt;
    strokePath.lineJoinStyle = kCGLineJoinBevel;
    [strokePath addArcWithCenter:center radius:rect.size.width/2-self.lineWidth/2 startAngle:M_PI/5 endAngle:M_PI/5-(M_PI*2-M_PI*3/5)*_progress clockwise:NO];
    [strokePath stroke];
    
}

@end
