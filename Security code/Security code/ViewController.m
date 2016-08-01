//
//  ViewController.m
//  Security code
//
//  Created by 李云祥 on 16/8/1.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Hash.h"
#import "SSKeychain.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@end

@implementation ViewController

#define kLoginUserNameKey       @"LoginUsernameKey"
#define kLoginPwdKey            @"LoginPasswordKey"
#define kLoginKeyServiceName    @"LoginKeyService"
/**
 1. 对用户密码进行base64编码
 2. 将编码后的信息保存在用户偏好
 3. 介绍base64实现原理
 4. md5介绍 & 使用技巧
 
 问题：
 
 无法记住有效的密码
 
 解决办法
 
 SSKeychain
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 读取用户偏好信息
    self.usernameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserNameKey];
    
    // 读取账户信息
    NSLog(@"%@", [SSKeychain allAccounts]);
    
    NSString *pwd = [SSKeychain passwordForService:kLoginKeyServiceName account:self.usernameText.text];
    self.pwdText.text = pwd;
    
    // 删除钥匙串
    [SSKeychain deletePasswordForService:kLoginKeyServiceName account:@"zhangsan"];
}

- (IBAction)login {
    NSString *username = self.usernameText.text;
    NSString *pwd = [self.pwdText.text md5String];
    
    NSLog(@"%@", pwd);
    
    NSString *urlString = @"http://10.0.1.7/login.php";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", username, pwd];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        // 数据处理代码...
        NSLog(@"%@", result);
        if ([result[@"userId"] intValue] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:kLoginUserNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 设置密码
            [SSKeychain setPassword:self.pwdText.text forService:kLoginKeyServiceName account:self.usernameText.text];
        }
    }];
}

@end
