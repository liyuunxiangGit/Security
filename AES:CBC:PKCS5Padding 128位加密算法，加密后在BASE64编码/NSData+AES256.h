//
//  NSData+AES256.h
//  AES
//
//  Created by 王忠伟 on 15/9/9.
//  Copyright (c) 2015年 hnzdkj. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
@interface NSData (AES256)
+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain;        /*加密方法,参数需要加密的内容*/
+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts; /*解密方法，参数数密文*/
@end
