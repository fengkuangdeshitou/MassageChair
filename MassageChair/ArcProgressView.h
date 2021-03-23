//
//  ArcProgressView.h
//  MassageChairSDK
//
//  Created by maiyou on 2021/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArcProgressView : UIView

@property(nonatomic,assign)CGFloat progress;

@property(nonatomic,strong)UIColor * progressColor;

@property(nonatomic,strong)UIColor * progressBackgroundColor;

@property(nonatomic,assign)CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
