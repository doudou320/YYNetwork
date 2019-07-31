//
//  ViewController.m
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import "ViewController.h"

#define HEHomeShufflingUrl @"/Api/NewIndex/carouseImageList"
#define Admin_HoueVision_getActivityRule @"/Admin/HoueVision/getActivityRule"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // GET
    [[YYNetworkManager shareManager] GETWithUrlString:Admin_HoueVision_getActivityRule parameters:nil success:^(NSURLSessionTask *task, id result) {
        
        NSLog(@"resut == %@",result);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
    
    // POST
    [[YYNetworkManager shareManager] POSTWithUrlString:HEHomeShufflingUrl parameters:@{@"uid":@"0"} success:^(NSURLSessionTask *task, id result) {
        NSLog(@"resut == %@",result);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
    
    [[YYNetworkManager shareManager] monitoringNetworkStatus:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"status == %ld",status);
        
    }];
}
@end
