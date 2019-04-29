//
//  ZFTableData.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/24.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface ZFTableData : NSObject

@property (nonatomic,strong)NSString *name;//昵称
@property (nonatomic,strong)NSString *text;//描述
@property (nonatomic,strong)NSString *videouri;//视频
@property (nonatomic,strong)NSString *profile_image;//头像
@property (nonatomic,strong)NSString *bimageuri;//背景图片

@property (nonatomic,strong)NSString *created_at;
@property (nonatomic,assign)NSInteger love;
@property (nonatomic,assign)NSInteger hate;
@property (nonatomic,assign)NSInteger comment;
@property (nonatomic,assign)NSInteger repost;
@property (nonatomic,strong)NSArray *top_cmt;
//帖子的类型
@property (nonatomic,assign)NSInteger type;
//图片的高度
@property (nonatomic,assign)NSInteger height;
@property (nonatomic,assign)NSInteger width;
@property (nonatomic,assign)CGFloat rowHight;
//中间frame
@property (nonatomic,assign)CGRect centerFrame;
@property (nonatomic,strong)NSString *smallImage;
@property (nonatomic,strong)NSString *image0;
//@property (nonatomic,strong)NSString *image0;
@property (nonatomic,assign)NSInteger playfcount;
@property (nonatomic,assign)NSInteger videotime;
@property (nonatomic,assign)NSInteger voicetime;
@property (nonatomic,strong)NSString *voiceuri;
//是否是gif图片
@property (nonatomic,assign)BOOL is_gif;
//是否是是大图
@property (nonatomic,assign)BOOL is_bigPicture;
@property (nonatomic,strong)NSString *ID;

@end
