//
//  YYParameterModel.h
//  YYNetwork
//
//  Created by HouEmba on 2019/7/25.
//  Copyright © 2019 HouEmba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYParameterModel : NSObject
/*
 *   上传的数据
 */
@property (nonatomic,strong) NSData *data;
/*
 *   上传的名字
 */
@property (nonatomic, copy) NSString *name;
/*
 *   上传的文件名
 */
@property (nonatomic, copy) NSString *fileName;
/*
 *   上传文件的e类型
 */
@property (nonatomic, copy) NSString *mineType;

@end


