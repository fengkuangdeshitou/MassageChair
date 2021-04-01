//
//  NSData+CRC16.h
//  MassageChair
//
//  Created by maiyou on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CRC16)

- (BOOL)checkCRC16;

- (int)crc16:(NSData *)data len:(int)len;

@end

NS_ASSUME_NONNULL_END
