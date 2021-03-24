//
//  BleManager.h
//  MassageChairSDK
//
//  Created by 王帅 on 2021/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleManager : NSObject

+ (instancetype)shareInstance;

- (void)writeValueToBle:(NSDictionary *)vaue;

@end

NS_ASSUME_NONNULL_END
