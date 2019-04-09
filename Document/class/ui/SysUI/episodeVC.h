//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface episodeVC : JYBasicViewController

@end

@interface episodeCell : JYBasicCell
@end

@interface CashAddressViewModel :JYBasicModel
@property (strong , nonatomic) NSString * imageUrl;
@property (strong , nonatomic) NSString * title;
@property (strong , nonatomic) NSString * desc;
@end

NS_ASSUME_NONNULL_END
