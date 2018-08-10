//
//  FYEnums.h
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//  常用枚举定义

#ifndef FYEnums_h
#define FYEnums_h

/**
 消息类型 枚举

 - kFYMessageTypeNone: 普通消息
 - kFYMessageTypeEstateCard: 房产卡片消息
 */
typedef NS_ENUM(NSUInteger, FYMessageType_t) {
    kFYMessageTypeNone,
    kFYMessageTypeEstateCard,
};

/**
 网络请求类型

 - FYAPIManagerRequestTypeGet:       Get 请求
 - FYAPIManagerRequestTypePost:      Post 请求
 - FYAPIManagerRequestTypeUpload:    上传
 - FYAPIManagerRequestTypeDownload   下载
 */
typedef NS_ENUM(NSUInteger, FYAPIManagerRequestType) {
    FYAPIManagerRequestTypeGet = 0,
    FYAPIManagerRequestTypePost,
    FYAPIManagerRequestTypeUpload,
    FYAPIManagerRequestTypeDownload                  
};

/**
 网络请求错误类型

 - FYAPIManagerErrorTypeDefault:     没有产生过API请求
 - FYAPIManagerErrorTypeSuccess:     API请求成功且返回数据正确
 - FYAPIManagerErrorTypeNoContent:   API请求成功但返回数据不正确
 - FYAPIManagerErrorTypeParamsError: 参数错误，此时manager不会调用API
 - FYAPIManagerErrorTypeTimeout:     请求超时
 - FYAPIManagerErrorTypeNoNetWork:   网络不通
 - FYAPIManagerErrorTypeInvalidURL:  请求失败， 无效的URL
 - FYAPIManagerErrorTypeNoHost:      服务器异常 （找不到服务器，服务器不支持等）
 - FYAPIManagerErrorTypeCancelled:   取消网络请求
 - FYAPIManagerErrorTypeUnknown      未知错误

 */
typedef NS_ENUM (NSUInteger, FYAPIManagerErrorType){
    FYAPIManagerErrorTypeDefault = 0,
    FYAPIManagerErrorTypeSuccess,
    FYAPIManagerErrorTypeNoContent,
    FYAPIManagerErrorTypeParamsError,
    FYAPIManagerErrorTypeTimeout,
    FYAPIManagerErrorTypeNoNetWork,
    FYAPIManagerErrorTypeInvalidURL,
    FYAPIManagerErrorTypeNoHost,
    FYAPIManagerErrorTypeCancelled,
    FYAPIManagerErrorTypeUnknown
};



/**
 弹出效果类型

 - FYPopupStyleTop:     从上面弹出  最后靠上
 - FYPopupStyleBottom:  从下面弹出 最后靠下
 - FYPopupStyleLeft:    从左侧弹出 最后靠左
 - FYPopupStyleRight:   从右侧弹出 最后靠右
 - FYPopupStyleCenter:  淡入淡出 最后居中
 - FYPopupStyleNone:    没有动画 最后居中
 - FYPopupStyleForeCenter: 弹出view淡入淡出缩放
 */
typedef NS_ENUM(NSUInteger, FYPopupStyle) {
    FYPopupStyleTop = 0,
    FYPopupStyleBottom,
    FYPopupStyleLeft,
    FYPopupStyleRight,
    FYPopupStyleCenter,
    FYPopupStyleMoreView,
    FYPopupStyleNone,
    FYPopupStyleForeCenter
};


/**
 房源类型

 - FYHouseTypeSell: 售房  买卖
 - FYHouseTypeRent: 租房  租赁
 - FYHouseTypeNew:  新房
 */
typedef NS_ENUM(NSUInteger, FYHouseType) {
    FYHouseTypeSell = 0,
    FYHouseTypeRent = 1,
    FYHouseTypeNew = 2,
};

/**
 物业类型
 - FYPropertyTypeEJU:   易居平台楼盘字典 类型
 - FYPropertyTypeResidential: 住宅
 - FYPropertyTypeShop: 商铺
 - FYPropertyTypeOffice: 写字楼
 - FYPropertyTypeCarport: 车位
 - FYPropertyTypeDepot: 仓库
 - FYPropertyTypePlant: 厂房
 - FYPropertyTypeApartment: 酒店式公寓
 */
typedef NS_ENUM(NSUInteger, FYPropertyType) {
    FYPropertyTypeEJU = 0,
    FYPropertyTypeResidential = 1,
    FYPropertyTypeShop = 2,
    FYPropertyTypeOffice = 3,
    FYPropertyTypeCarport = 4,
    FYPropertyTypeDepot = 5,
    FYPropertyTypePlant = 6,
    FYPropertyTypeApartment = 7,
};


/**
 页面操作类型

 - FYInterfaceOperationTypeAdd:    新增
 - FYInterfaceOperationTypeModify: 修改
 */
typedef NS_ENUM(NSUInteger, FYInterfaceOperationType) {
    FYInterfaceOperationTypeAdd = 1,
    FYInterfaceOperationTypeModify = 2
};


/**
 业务操作类型

 - FYOperationTypeHouse: 房源
 - FYOperationTypeClient: 客源
 */
typedef NS_ENUM(NSUInteger, FYOperationType) {
    FYOperationTypeHouse = 1,
    FYOperationTypeClient = 2     
};


/**
 外出状态

 - FYGooutTypeNoGoout: 未外出
 - FYGooutTypeGoingout: 外出中
 - FYGooutTypeGoneout: 已外出
 - FYGooutTypeCancell: 已取消
 - FYGooutTypeExpired: 已过期
 */
typedef NS_ENUM(NSUInteger, FYGooutType) {
    FYGooutTypeNoGoout = 0,
    FYGooutTypeGoingout = 1,
    FYGooutTypeGoneout = 2,
    FYGooutTypeCancell = 3,
    FYGooutTypeExpired = 4
};

/**
 报备带看单
 
 - FYConfirmLookPageTypeUpload: 上传带看单
 - FYConfirmLookPageTypeLook: 查看带看单
 */
typedef NS_ENUM(NSUInteger, FYConfirmLookPageType) {
    FYConfirmLookPageTypeUpload = 0,
    FYConfirmLookPageTypeLook = 1,
};

/**
 新房报备类型
 
 - FYReportStatusTypeReportEffective: 报备有效
 - FYReportStatusTypeHaveLook: 已带看
 - FYReportStatusTypeHaveConfirm: 已大定
 - FYReportStatusTypeHaveSell: 已成销
 - FYReportStatusTypePartDone: 部分结佣
 - FYReportStatusTypeHaveDone: 已结佣

 */
typedef NS_ENUM(NSUInteger, FYReportStatusType) {
    FYReportStatusTypeReportEffective = 0,
    FYReportStatusTypeHaveLook = 1,
    FYReportStatusTypeHaveConfirm = 2,
    FYReportStatusTypeHaveSell = 3,
    FYReportStatusTypePartDone = 4,
    FYReportStatusTypeHaveDone = 5,
};

#endif /* FYEnums_h */
