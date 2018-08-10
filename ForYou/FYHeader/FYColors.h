//
//  FYColors.h
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//  所有颜色的宏定义

#ifndef FYColors_h
#define FYColors_h

//color format
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//helex color string: #0c2933
#define HexColor(string)                    [UIColor colorFromHexString:string]


// 颜色定义区
#define color_background_white              RGB(255, 255, 255)      //HexColor(@"#ffffff")
#define color_background_opaque             RGBA(0, 0, 0, 0.5)      //HexColor(@"#000000")


#define color_line                          RGB(221, 221, 221)      //HexColor(@"#dddddd")
#define color_system_line                          RGB(0x7f, 0x7f, 0x7f)      //HexColor(@"#7f7f7f")
//tabBar 默认 背景颜色
#define color_tabBar_background_normal      RGB(249, 249, 249)      //HexColor(@"#f9f9f9")
//tabBar 选中 背景颜色
#define color_tabBar_background_selected    RGB(252, 86, 86)        //HexColor(@"#fc5656")
//navBar Tint 颜色
#define color_navBar_Tint                   RGB(232, 62, 65)
//navBarItem Tint 颜色
#define color_navBarItem_Tint               RGB(250, 250, 250)        //HexColor(@"#fc5656")


//纯白色 不透明
#define color_white                         RGB(255,255,255)        //HexColor(@"FFFFFF")
//纯白色 不透明0.6
#define color_white_alpha6                  RGBA(255,255,255,0.6)   //HexColor(@"FFFFFF")
//纯黑色 不透明
#define color_black                         RGB(0,0,0)              //HexColor(@"000000")

//纯黑色 透明度为0.7
#define color_black_alpha7                  RGBA(0,0,0,0.7)         //HexColor(@"000000")
//纯黑色 透明度为0.3
#define color_black_alpha3                  RGBA(0,0,0,0.3)         //HexColor(@"000000")
//纯黑色 透明度为0.4
#define color_black_alpha4                  RGBA(0,0,0,0.4)         //HexColor(@"000000")
//纯黑色 透明度为0.1
#define color_black_alpha1                  RGBA(0,0,0,0.1)         //HexColor(@"000000")


//纯黑色 透明度为0.08
#define color_black_alphaShadow               RGBA(0,0,0,0.08)         //HexColor(@"000000")
//黑色 333333
#define color_black3                        RGB(51,51,51)           //HexColor(@"333333")
//黑色 666666
#define color_black6                        RGB(102,102,102)        //HexColor(@"666666")
//黑色 999999
#define color_black9                        RGB(153,153,153)       //HexColor(@"999999")
//无色
#define color_clear                         [UIColor clearColor]

#define color_text_3gray                    RGB(204, 204, 204)      //HexColor(@"#cccccc")

#define color_text_2black                   RGB(51, 51, 51)         //HexColor(@"#333333")
//偏黑色
#define color_bigimage_ground                   RGB(0x26, 0x26, 0x26)         //HexColor(@"#262626")

// 详情字体偏灰色的     
#define color_text_gray_6e                   RGB(0x6e, 0x6e, 0x6e)         //HexColor(@"#262626")

// 详情字体浅蓝色
#define color_text_00a0e9                   RGB(0x00, 0xa0, 0xe9)         //HexColor(@"#00a0e9")
#define color_btn_eff7fc                    RGB(0xef, 0xf7, 0xfc)          ////HexColor(@"#eff7fc")

#define color_f5ad54                    RGB(0xf5, 0xad, 0x54)          ////HexColor(@"#f5ad54")
#define color_btn_ff2c52                    RGB(0xff, 0x2c, 0x52)          ////HexColor(@"#ff2c52")
#define color_red_fa5728                    RGB(0xfa, 0x57, 0x28)          ////HexColor(@"#fa5728")
#define color_btn_ec4b39                   RGB(0xec, 0x4b, 0x39)          ////HexColor(@"#ec4b39")
#define color_gray_c3c3c7                 RGB(0xc3, 0xc3, 0xc7)          ////HexColor(@"#c3c3c7")
#define color_detail_background_f5f5f5    RGB(0xf5, 0xf5, 0xf5)          ////HexColor(@"#f5f5f5")
#define color_line_eeeeee                 RGB(0xee, 0xee, 0xee)          ////HexColor(@"#eeeeee")
#define color_line_e6e6e6                 RGB(0xe6, 0xe6, 0xe6)          ////HexColor(@"#e6e6e6")描边颜色
#define color_line_f2f2f2                 RGB(0xf2, 0xf2, 0xf2)          ////HexColor(@"#f2f2f2")描边颜色
#define color_btn_f7f7f8                 RGB(0xf7, 0xf7, 0xf8)          ////HexColor(@"#f7f7f8")背景颜色
#define color_mike_db4c4c                    RGB(0xdb, 0x4c, 0x4c)          ////HexColor(@"#db4c4c")
#define color_line_b2b2b2                    RGB(0xb2, 0xb2, 0xb2)          ////HexColor(@"#b2b2b2")
#define color_line_f47a62                    RGB(0xf4, 0x7a, 0x62)          ////HexColor(@"#f47a62")
#define color_fff0ee                   RGB(0xff, 0xf0, 0xee)          ////HexColor(@"#fff0ee")

#define color_line_e5e5e5                    RGB(0xe5, 0xe5, 0xe5)          ////HexColor(@"#e5e5e5")
#define color_line_5faee3                    RGB(0x5f, 0xae, 0xe3)          ////HexColor(@"#5faee3")
#define color_3cbb41                   RGB(0x3c, 0xbb, 0x41)          ////HexColor(@"#3cbb41")

#define color_red_e8382b                    RGB(232, 56, 43)         //HexColor(@"e8382b")

#define color_red_ea4c40                    RGB(234, 76, 64)             //HexColor(@"ea4c40")
#define color_red_f45055                    RGB(0xf4, 0x50, 0x55)        //HexColor(@"f45055")


#define color_red_ff2c52                    RGB(255, 44, 82)         //HexColor(@"ff2c52")

#define color_red_e85343                    RGB(232, 83, 67)         //HexColor(@"e85343")

#define color_red_ee483c                    RGB(238, 72, 60)         //HexColor(@"ee483c")


#define color_gray_dddddd                   RGB(221, 221, 221)      //HexColor(@"#dddddd")

#define color_gray_a4a4a4                   RGB(164, 164, 164)      //HexColor(@"#a4a4a4")
#define color_gray_a8a8a8                   RGB(0xa8, 0xa8, 0xa8)      //HexColor(@"#a8a8a8")

#define color_black_666666                  RGB(102,102,102)        //HexColor(@"666666")

#define color_gray_808080                   RGB(128,128,128)        //HexColor(@"808080")
#define color_blue_00a0e9                   RGB(0,160,233)        //HexColor(@"00a0e9")
#define color_blue_499ee3                   RGB(73,158,227)        //HexColor(@"499ee3")


#define color_gray_f6f6f6                   RGB(246,246,246)        //HexColor(@"f6f6f6")
#define color_gray_c5c5c5                   RGB(197,197,197)        //HexColor(@"c5c5c5")

#define color_userIcon_e1d7e2                   RGB(225,215,226)        //HexColor(@"e1d7e2")
#define color_userIcon_4a95ec                   RGB(74,149,236)        //HexColor(@"4a95ec")

#define color_userIcon_f09c38                   RGB(240,156,56)        //HexColor(@"f09c38")
#define color_userIcon_68ac5b                   RGB(104,172,91)        //HexColor(@"68ac5b")
#define color_userIcon_8e33aa                   RGB(142,51,170)        //HexColor(@"8e33aa")
#define color_userIcon_56b9d1                   RGB(86,185,209)        //HexColor(@"56b9d1")
#define color_userIcon_e05241                   RGB(224,82,65)        //HexColor(@"e05241")


#define color_cell_line                     RGB(238,238,238)         //HexColor(@"eeeeee")

#define color_red_f8f8f9                    RGB(248,248,249)        //HexColor(@"f8f8f9")

#define color_oronge_f2a530                 RGB(242,165,48)        //HexColor(@"f2a530")
#define color_yellow_ffc101                 RGB(255,193,1)         //HexColor(@"ffc101")
#define color_yellow_ffdb01                 RGB(255,219,1)         //HexColor(@"ffdb01")


#define color_oronge_f2aa3d                 RGB(242,170,61)        //HexColor(@"f2aa3d")
#define color_oronge_f3d1ae                RGB(0xf3,0xd1,0xae)        //HexColor(@"f3d1ae")

#define color_oronge_ff660a                 RGB(255,102,10)        //HexColor(@"ff660a")


#define color_oronge_ef873a                 RGB(239,135,58)        //HexColor(@"ef873a")
#define color_red_FC6463                 RGB(252,100,99)        //HexColor(@"FC6463")
#define color_red_ec6632                 RGB(0xec,0x66,0x32)        //HexColor(@"ec6632")

#define color_gray_E7E7E7                 RGB(231,231,231)        //HexColor(@"E7E7E7")

#define color_eb9077                 RGB(235,144,119)        //HexColor(@"eb9077")
#define color_fbf7f6                 RGB(251,247,246)        //HexColor(@"fbf7f6")

#define color_c5aa6a                 RGB(197,170,106)        //HexColor(@"c5aa6a")
#define color_fbf8f0                 RGB(251,248,240)        //HexColor(@"fbf8f0")

#define color_ecc146                 RGB(236,193,70)        //HexColor(@"ecc146")
#define color_fcf9ed                 RGB(252,249,237)        //HexColor(@"fcf9ed")

#define color_f19e3a                 RGB(241,158,58)        //HexColor(@"f19e3a")
#define color_fef8ef                 RGB(254,248,239)        //HexColor(@"fef8ef")

#define color_e79595                 RGB(231,149,149)        //HexColor(@"e79595")
#define color_fef5f5                 RGB(254,245,245)        //HexColor(@"fef5f5")

#define color_ff9909                 RGB(255,153,9)          //HexColor(@"ff9909")
#define color_fff8ee                 RGB(255,248,238)        //HexColor(@"fff8ee")

#define color_a9bacd                 RGB(169,186,205)         //HexColor(@"a9bacd")
#define color_f6f8fa                 RGB(246,248,250)        //HexColor(@"f6f8fa")

#define color_eb9077                 RGB(235,144,119)         //HexColor(@"eb9077")
#define color_fbf7f6                 RGB(251,247,246)        //HexColor(@"fbf7f6")

#define color_fcf9ed                 RGB(252,249,237)        //HexColor(@"fcf9ed")
#define color_ecc146                 RGB(236,193,70)         //HexColor(@"ecc146")

#define color_eca846                 RGB(236,168,70)         //HexColor(@"eca846")
#define color_fef7f5                 RGB(254,247,245)        //HexColor(@"fef7f5")

#define color_57b13e                 RGB(87,177,62) 
#endif /* FYColors_h */
