//
//  ViewController.m
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import "ViewController.h"

#define HEHomeShufflingUrl @"/Api/NewIndex/carouseImageList"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    [[YYNetworkManager shareManager] POSTWithUrlString:HEHomeShufflingUrl parameters:@{@"uid":@"0"} success:^(NSURLSessionDataTask *task, id result) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
//    [[YYNetworkManager shareManager] POSTWithUrlString:[NSString stringWithFormat:@"%@%@",HouEMainUrl,HEHomeShufflingUrl] parameters:@{@"uid":@"0"} success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
}


@end
