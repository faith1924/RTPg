//
//  ABCInterfaceUrl.h
//  ABCMobileProject
//
//  Created by mmy on 2018/4/20.
//  Copyright © 2018年 mmy. All rights reserved.
//

//====================接口======================
#ifndef ABCInterfaceUrl_h
#define ABCInterfaceUrl_h

#define ABAOfficialServerUrl @"http://api.v1.xxx.xxx/init-execute.jsp"//正式服务器
#define ABATestServerUrl1 @"http://api1.mylianmeng.cn/"//测试服务器1
#define ABATestServerUrl2 @"http://api.mylianmeng.cn/"//正式服务器
#define ABATestServerUrl3 @"http://ios.mylianmeng.cn/"//苹果服务器

#define ABAUserProtocols @"https://bizhong.net.cn/reg.html"//用户协议
#define ABAAboutLP @"https://bizhong.net.cn/about.html"//关于币众

//个人信息
#define ABAAppCandyAdInit @"init-bin/navigation.jsp" //广告
#define ABAMineAssetDetailInfo @"pay-bin/user-property-detail.jsp"//我的资产账单明细
#define ABAMineAssetsInfo @"pay-bin/user-property.jsp"//我的资产
#define ABAMineAssetAddAddress @"pay-bin/user-property-address-add.jsp"//添加提现地址
#define ABAMineAssetDeleteAddress @"pay-bin/user-property-address-delete.jsp"//删除提现地址
#define ABAMineAssetAddressList @"pay-bin/user-property-address.jsp"//提现地址列表
#define ABAMineAssetCashDetault @"pay-bin/user-property-out-init.jsp"//提现初始化接口
#define ABAMineAssetCashList @"pay-bin/user-property-out-log.jsp"//提现记录列表
#define ABAMineAssetCashOperation @"pay-bin/user-property-out-operate.jsp"//资产提现


#define ABAGetAppVersionNumberUrl @"system-version.jsp"//退出
#define ABALogoutUrl @"user-out.jsp"//退出
#define ABALoginUrl @"user-login.jsp"//登录
#define ABARegesterUrl @"user-login.jsp"//注册
#define ABAGetValidationUrl @"message-vercode.jsp"//获取验证码
#define ABAResetPasswordUrl @"user-retrieve-password.jsp"//找回密码
#define ABAPayPasswordUrl @"safe-bin/pay-pass.jsp"//支付密码设置
#define ABALoginPasswordUrl @"safe-bin/login-pass.jsp"//登录密码设置
#define ABAGetPersonMessageUrl @"user-info.jsp"//个人信息
#define ABAGetEnergyInfoUrl @"user-energy-info.jsp"//获取能量值


#define ABAUploadImgaesUrl @"upload-bin/image.jsp"//上传图片
#define ABAUploadBatchImgaesUrl @"upload-bin/image-batch.jsp"//批量上传图片
#define ABAPersonHomePageUserInfo @"user-home-user.jsp"//个人主页用户信息
#define ABAPersonHomePageList @"user-home-list-new.jsp"//个人主页列表
#define ABASetPersonHomePagePermission @"user-home-homepage-authOperate.jsp"//个人主页权限设置

//订阅模块
#define ABARecommendSubscribeListUrl @"subscribe-bin/recommend-list.jsp"//推荐订阅列表
#define ABAGetSubscribeAuthorListUrl @"user-home-subscribe-list.jsp"//订阅列表
#define ABAGetSubscribeAuthorSearchUrl @"subscribe-bin/recommend-search.jsp"//订阅搜索
#define ABASubscribeJoinBlockChainsList @"miningchain-bin/article-list.jsp"//挖矿上链
#define ABASubscribeOperationUrl @"subscribe-bin/follow.jsp"//添加取消订阅
#define ABAgetPlatformListUrl @"init-bin/platform-type.jsp"//获取平台类型列表
#define ABASubscribeArticleListUrl @"subscribe-bin/article-list.jsp"//已订阅媒体文章列表
#define ABAMediaArticleDetailUrl @"platform-bin/article-show.jsp"//自媒体文章详情
#define ABASubscribeConfigurationInfo @"subscribe-bin/recommend-init-info.jsp"//订阅配置信息
#define ABASubscribeList @"subscribe-bin/recommend-type-list.jsp"//订阅列表
#define ABAHadSubscribeMediaHomepageUrl @"subscribe-bin/selfmedia.jsp"//已订阅自媒体主页
#define ABAGetHotKeyWordsUrl @"subscribe-bin/recommend-search-keyword.jsp"//- 推荐订阅搜索 - 热搜词
#define ABAGetSourceCategoryList @"miningchain-bin/home-init.jsp"//挖矿上链分类

#define ABACandyVerifyInterface @"platform-bin/candy-verify.jsp"//糖果验证
#define ABACandyVerifyClose @"platform-bin/candy-verify-istips.jsp"//延迟糖果验证
#define ABAReportBusinessUrl @"platform-bin/report-form.jsp"//举报
#define ABAGetReportTypeUrl @"platform-bin/report-type.jsp"//举报类型
#define ABASuggestFeedbackUrl @"user-bin/help-feedback.jsp" //意见反馈 content
#define ABAGetSupportMessageList @"user-bin/help-list.jsp" //帮助列表 page


#define ABACollectArticle @"user-bin/collection-article.jsp"//文章收藏
#define ABACollectArticleList @"user-bin/collection-article-list.jsp"//收藏列表
#define ABADeleteCollectArticle @"user-bin/collection-article-del.jsp"//删除收藏
#define ABAGetHistoryScanArticleList @"user-bin/views-article-list.jsp"//历史浏览
#define ABADeleteHistoryScanArticleList @"user-bin/views-article-del.jsp"//删除历史浏览
#define ABAShareSuccessCallBack @"platform-bin/share-callback.jsp"//分享成功

//行情
#define ABAGetMarketList @"quotation-bin/list.jsp"//行情列表
#define ABAMarketOperation @"quotation-bin/follow.jsp"//行情添加取消关注
#define ABAMarketSearch @"quotation-bin/search.jsp"//行情搜索

//众链
#define ABABlockChainsType @"crowdchain-bin/chain-type.jsp"//获取众链类型
#define ABACommunitySearchList @"crowdchain-bin/chain-home-search.jsp"//社区内搜索
#define ABACommunityReleaseAnnouncement @"crowdchain-bin/chain-notice-add-info.jsp"//社区内发布公告
#define ABACommunityAnnouncementDetail @"crowdchain-bin/chain-notice-show.jsp"//公告详情
#define ABADeleteaAnouncementDetail @"crowdchain-bin/delete-notice.jsp"//删除公告

#define ABANewLettersOperation @"crowdchain-bin/newsflash/article-down-up-handle.jsp"//利好利空
#define ABANewLettersList @"crowdchain-bin/newsflash/article-list-detail.jsp"//快讯列表
#define ABABlockChainNewLetters @"crowdchain-bin/newsflash/article-list.jsp"//众链首页快讯
#define ABABlockChainHomePageInit @"crowdchain-bin/home-init.jsp"//众链首页初始化接口
#define ABAGetLaunchActivityImageInit @"init-appStartExecute.jsp"//app初始化
#define ABAGetActivityConfi @"platform-bin/activity-info.jsp"//app初始化获取活动


#define ABAReleaseBlockChain @"crowdchain-bin/chain-release-v2.jsp"//发起众链
#define ABABlockChainEditMessageInfo @"pay-bin/chain-modify.jsp"//修改众链信息
#define ABAReleaseBlockRole @"crowdchain-bin/chain-release-rule.jsp"//发链规则
#define ABAGetCampaignCategoryList @"crowdchain-bin/chain-attend-init.jsp"//竞选分类
#define ABABlockCampaignSearch @"crowdchain-bin/chain-attend-search.jsp"//竞选搜索

#define ABAGetReleaseBlockChainInit @"crowdchain-bin/chain-release-init.jsp"//发起众链初始化接口
#define ABAGetBlockChainsHotKeywords @"crowdchain-bin/chain-search-keyword.jsp"//获取众链热搜词
#define ABAGetMineBlockChainsKeywordsSearchResults @"user-home-crowdchain-search.jsp"//获取我的众链搜索结果
#define ABAGetBlockChainsKeywordsSearchResults @"crowdchain-bin/chain-search.jsp"//获取众链搜索结果
#define ABAGetBlockChainsUserKeywordsSearchResults @"crowdchain-bin/chain-search-user.jsp"//获取众链搜索结果

#define ABAGetHotBlockChainsList @"crowdchain-bin/chain-type-list.jsp"//获取热门众链
#define ABAGetBannerImageView @"crowdchain-bin/chain-slide.jsp"//获取轮播图
#define ABAGetOnlineBlockChainsList @"crowdchain-bin/chain-list.jsp"//已在线众链
#define ABAGetCommunityHomePageList @"crowdchain-bin/chain-home-list.jsp"//众链社区主页列表
#define ABAGetCommunityBlockChainsDetail @"crowdchain-bin/chain-home.jsp"//众链社区主页
#define ABAGetCampaignList @"crowdchain-bin/chain-attend-user-list.jsp"//竞选人列表

#define ABAGetPersonHomePageBlockChainsList @"user-home-crowdchain-list.jsp"//我的众链
#define ABAGetUserPersonHomePageBlockChainsList @"user-home-crowdchain-list-new.jsp"//他的众链
#define ABAGetBlockChainsWorkerList @"crowdchain-bin/chain-member-list.jsp"//矿工列表
#define ABAGetHotDynamicBlockChainsList @"crowdchain-bin/chain-index-dynamic.jsp"//首页热门众链
#define ABAGetConcentrationBlockChainsList @"crowdchain-bin/chain-index-choicest.jsp"//首页精选热门

#define ABAGetBlockChainsDetailInfo @"crowdchain-bin/chain-home-datum.jsp"//社区资料
#define ABAQuitBlockChainsCommunity @"crowdchain-bin/chain-home-out.jsp"//退出社区
#define ABAJoinBlockChainsCommunity @"crowdchain-bin/chain-home-add.jsp"//加入社区
#define ABACommunityDynamicDetailUrl @"crowdchain-bin/chain-dynamic-show.jsp"//动态详情
#define ABADeleteComunityDynamicUrl @"crowdchain-bin/deletedynamic.jsp"//删除动态
#define ABAReleaseBlockChainsCommunity @"crowdchain-bin/chain-dynamic-publish.jsp"//发布社区动态
#define ABAReleaseConfigurationInfo @"crowdchain-bin/chain-dynamic-publish-info.jsp"//发布动态配置信息
#define ABADynamicOperationCancelPlaceTop @"crowdchain-bin/chain-dynamic-qxzd.jsp"//取消置顶

#define ABAMineArticleClassList @"user-bin/user-info/article-init.jsp"//我的文章分类列表
#define ABAUserReleaseDynamicList @"user-bin/user-info/dynamic-list.jsp"//已登录用户动态列表
#define ABAUserReleaseArticleList @"user-bin/user-article-list.jsp"//已登录用户文章列表

#define ABAGetCommentArticleDetailList @"crowdchain-bin/chain-comment-list.jsp"//获取评论列表
#define ABAReleaseDetailArticleComment @"crowdchain-bin/chain-comment-publish.jsp"//发表评论
#define ABAGetCommentDetailList @"crowdchain-bin/chain-comment-show-list.jsp"//获取评论详情
#define ABAGetCommentDetailHeader @"crowdchain-bin/chain-comment-show.jsp"//获取评论头
#define ABAGetCommentInitConfList @"crowdchain-bin/chain-comment-sort-name-list.jsp"//评论分类初始化
#define ABADeleteSingleComment @"crowdchain-bin/chain-comment-del.jsp"//删除评论


#define ABACommunityDeleteArticle @"crowdchain-bin/delete-article.jsp"//删除文章
#define ABACommunityDeleteNotice @"crowdchain-bin/soft-delete-notice.jsp"//删除公告
#define ABACommunityDeleteDynamic @"crowdchain-bin/soft-delete-dynamic.jsp"//删除动态

#define ABAGetUserWarnInfo @"platform-bin/warm-check.jsp"//警告状态
#define ABAWarnOperationInterface @"platform-bin/warn-operate.jsp"//警告操作
#define ABABanUserListInterface @"platform-bin/ban-speek-list.jsp"//禁言列表
#define ABABanOperationInterface @"platform-bin/ban-speek-operate.jsp"//禁言操作
#define ABABanTypeConfigurationInfo @"platform-bin/ban-speek-type-list.jsp"//禁言类型
#define ABAWarningTypeConfigurationInfo @"platform-bin/warm-type-list.jsp"//警告配置信息
#define ABABanDurningConfigurationInfo @"platform-bin/ban-speek-time-list.jsp"//禁言时长
#define ABAAssignOperationAdministrator @"crowdchain-bin/become-manager.jsp"//指派管理员
#define ABAGetAdministratorList @"crowdchain-bin/manager-list.jsp"//获取管理员列表
#define ABAGetUserBanInfo @"platform-bin/ban-speek-check.jsp"//获取禁言状态


//竞选
#define ABAGetAllCampaignBlockList @"crowdchain-bin/chain-index.jsp"//众链首页
#define ABAGetUserCampaignBlockList @"crowdchain-bin/chain-attend-list.jsp"//获取个人众链列表
#define ABAUserBlockChainsListInit @"user-home-init.jsp"//获取个人众链列表
#define ABAGetCampaignBlockDetailInfo @"crowdchain-bin/chain-attend-show.jsp"//获取竞选详情
#define ABAGetCampaignBlockAdditionalInfo @"crowdchain-bin/chain-attend-append-get.jsp"//获取追加众链信息
#define ABAJoinBlockCampaign @"crowdchain-bin/chain-append-join.jsp"//加入竞选
#define ABABlockCampaignAdditionalAmount @"crowdchain-bin/chain-attend-append.jsp"//追加金额
#define ABAGetPayFeeInfomation @"pay-bin/lp-payment-get.jsp"//获取支付信息
#define ABASubmitPayFeeInfomation @"pay-bin/lp-payment.jsp"//提交支付信息
#define ABAGetPayWithoutPasswordConfigurationInfo @"safe-bin/pay-init.jsp"//免密支付初始化
#define ABASubmitPayInfo @"safe-bin/pay-form-nopassmoney.jsp"//提交小额配置信息
#define ABAPayWithOutPassword @"safe-bin/pay-form-isneedpassword.jsp"//提交小额配置信息


//lp模块
#define ABAGetRechargeRecordList @"pay-bin/lp-recharge-log.jsp"//获取lp充值记录
#define ABAGetUserLpInfo @"pay-bin/lp-recharge.jsp"//获取用户信息


//文章转投
#define ABAUserAddAttentionAuthor @"subscribe-bin/user-follow.jsp"//添加取消关注
#define ABAGetArticleHadForwardedList @"subscribe-bin/article-chain-list.jsp"//获取已转投列表
#define ABAGetArticleCanForwardList @"subscribe-bin/article-chain-reprint-list.jsp"//获取可转投文章列表
#define ABAUserEnjoyClick @"user-click-add.jsp"//用户点赞
#define ABAUserCommentEnjoyClick @"crowdchain-bin/chain-comment-praise.jsp"//评论点赞
#define ABAGetUserAttentionList @"user-bin/user-info/follow-list.jsp"//用户关注列表
#define ABAGetUserFansList @"user-bin/user-info/fans-list.jsp"//用户粉丝列表


//用户资料
#define ABAGetUserInfo @"user-datum-info.jsp"//用户信息获取
#define ABAEditUserInfo @"user-datum-set.jsp"//用户信息修改

//LP
#define ABAIncomePerDayLpList @"pay-bin/lp-home-daylog.jsp"//每日收益列表
#define ABALPBalanceList @"pay-bin/lp-home-change-log.jsp"//lp账单列表
#define ABALPHomePageInfomation @"pay-bin/lp-home.jsp" //主页接口

//链上热文
#define ABAGetBlockHotArticleList @"crowdchain-bin/crowdhot/article-list.jsp"//链上热文
#define ABASearchBlockChainsHotArticleList @"crowdchain-bin/crowdhot/article-search.jsp"//链上热文搜索
#define ABAGetBlockChainsHotArticleCategory @"platform-bin/article-category.jsp"//链上分类


//消息中心
#define ABAGetInteractiveMessageList @"user-bin/interact-msg.jsp"//互动消息
#define ABAGetBlockChainMessageList @"user-bin/zhonglian-msg.jsp"//众链消息
#define ABABlockChainsSetTop @"user-home-crowdchain-isTop.jsp"//众链置顶
#define ABAGetPrivateMessageList @"user-bin/list-sixin-msg.jsp"//私信
#define ABAPrivateMessageDetail @"user-bin/list-sixin-msg-contentlsit.jsp"//私信详情
#define ABAGetSystemMessageList @"user-bin/system-msg.jsp"//系统消息
#define ABAGetMessageCenterBtnStatus @"user-bin/check-msglist-isread.jsp"//获取消息中心红点状态
#define ABASetMessageAllRead @"user-bin/setallread.jsp"//设置全部已读
#define ABABlockChainMessageListDetail @"user-bin/zhonglian-msg-content.jsp"//众链消息详情

#define ABAMessageCenterDelete @"user-bin/msg-delete.jsp"//消息中心删除
#define ABAMessageCenterSendMessage @"user-bin/msg-send.jsp"//发送消息
#define ABAMessagePlaceTop @"user-bin/msg-setmsgtop.jsp"//消息置顶

#define ABCGetDnsIpInterface @"http://119.29.29.29/d?dn=app.urbanparking.cn&ip=app.urbanparking.cn"//域名解析
#define ABCcGetVersionInterface @"https://itunes.apple.com/lookup?id=1210560805"//根据build检查版本更新
#define ABCSendCrashLogToServer @""



#endif /* ABCInterfaceUrl_h */
