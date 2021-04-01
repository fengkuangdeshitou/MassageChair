//
//  NSString+SwitchData.h
//  MassageChair
//
//  Created by maiyou on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SwitchData)

- (NSData*)convertBytesStringToData;

- (NSString *)decimalToHex;

- (NSString *)decimalToHexWithLength:(NSUInteger)length;

- (NSString *)hexToDecimal;

- (NSString *)binaryToDecimal;

- (NSString *)decimalToBinary;

@end

NS_ASSUME_NONNULL_END
