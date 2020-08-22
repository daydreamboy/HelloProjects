//
//  WCIconFont.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCIconFont.h"
#import "UIFont+WCFont.h"

#define TBIconFontMap_TAOBAO @{\
@"1212":@"\U0000e08a",\
@"38":@"\U0000e09a",\
@"activity":@"\U0000b37a",\
@"activity_fill":@"\U0000b37b",\
@"add":@"\U0000d10a",\
@"add_light":@"\U0000d10d",\
@"address_book":@"\U0000b28a",\
@"album":@"\U0000b85a",\
@"all":@"\U0000b99a",\
@"appreciate":@"\U0000b10a",\
@"appreciate_fill":@"\U0000b10b",\
@"appreciate_fill_light":@"\U0000b10e",\
@"appreciate_light":@"\U0000b10d",\
@"apps":@"\U0000b81a",\
@"arrow_left_fill":@"\U0000f08b",\
@"arrow_up_fill":@"\U0000f09b",\
@"ask":@"\U0000f32a",\
@"ask_fill":@"\U0000f32b",\
@"attention":@"\U0000b35a",\
@"attention_favor":@"\U0000f23a",\
@"attention_favor_fill":@"\U0000f23b",\
@"attention_fill":@"\U0000b35b",\
@"attention_forbid":@"\U0000f22a",\
@"attention_forbid_fill":@"\U0000f22b",\
@"attention_light":@"\U0000b35d",\
@"auction":@"\U0000f76a",\
@"baby":@"\U0000b75a",\
@"baby_fill":@"\U0000b75b",\
@"back":@"\U0000a07a",\
@"back_android":@"\U0000f39a",\
@"back_android_light":@"\U0000f39d",\
@"back_delete":@"\U0000d27a",\
@"back_light":@"\U0000a07d",\
@"backward_fill":@"\U0000d23b",\
@"bad":@"\U0000b78a",\
@"bar_code":@"\U0000b44a",\
@"big":@"\U0000e02a",\
@"bomb":@"\U0000f11a",\
@"bomb_fill":@"\U0000f11b",\
@"brand":@"\U0000b73a",\
@"brand_fill":@"\U0000b73b",\
@"brand_sale":@"\U0000f14a",\
@"brand_sale_fill":@"\U0000f14b",\
@"calendar":@"\U0000b93a",\
@"camera":@"\U0000b22a",\
@"camera_add":@"\U0000b79a",\
@"camera_fill":@"\U0000b22b",\
@"camera_light":@"\U0000b22d",\
@"camera_rotate":@"\U0000b51a",\
@"cardboard":@"\U0000f21a",\
@"cardboard_fill":@"\U0000f21b",\
@"cardboard_forbid":@"\U0000f21c",\
@"cart":@"\U0000a04a",\
@"cart_fill":@"\U0000a04b",\
@"cart_fill_light":@"\U0000a04e",\
@"cart_light":@"\U0000a04d",\
@"cascades":@"\U0000a14a",\
@"change_light":@"\U0000f50d",\
@"check":@"\U0000d01a",\
@"choiceness":@"\U0000b74a",\
@"choiceness_fill":@"\U0000b74b",\
@"circle":@"\U0000f24a",\
@"circle_fill":@"\U0000f24b",\
@"close":@"\U0000d03a",\
@"close_light":@"\U0000d03d",\
@"clothes":@"\U0000b76a",\
@"clothes_fill":@"\U0000b76b",\
@"coffee":@"\U0000f42d",\
@"coin":@"\U0000e23a",\
@"command":@"\U0000b89a",\
@"command_fill":@"\U0000b89b",\
@"comment":@"\U0000b18a",\
@"comment_fill":@"\U0000b18b",\
@"comment_fill_light":@"\U0000b18e",\
@"comment_light":@"\U0000b18d",\
@"community":@"\U0000a22a",\
@"community_fill":@"\U0000a22b",\
@"community_fill_light":@"\U0000a22e",\
@"community_light":@"\U0000a22d",\
@"copy":@"\U0000b65a",\
@"countdown":@"\U0000b62a",\
@"countdown_fill":@"\U0000b62b",\
@"crazy":@"\U0000f13a",\
@"crazy_fill":@"\U0000f13b",\
@"creative":@"\U0000b77a",\
@"creative_fill":@"\U0000b77b",\
@"crown":@"\U0000f07a",\
@"crown_fill":@"\U0000f07b",\
@"cut":@"\U0000b92a",\
@"delete":@"\U0000b08a",\
@"delete_fill":@"\U0000b08b",\
@"delete_light":@"\U0000b08d",\
@"deliver":@"\U0000c03a",\
@"deliver_fill":@"\U0000c03b",\
@"discover":@"\U0000a03a",\
@"discover_fill":@"\U0000a03b",\
@"down":@"\U0000b59a",\
@"down_light":@"\U0000b59d",\
@"dress":@"\U0000f43d",\
@"edit":@"\U0000b06a",\
@"edit_light":@"\U0000b06d",\
@"emoji":@"\U0000b09a",\
@"emoji_add":@"\U0000f10a",\
@"emoji_fill":@"\U0000b09b",\
@"emoji_flash_fill":@"\U0000f16b",\
@"emoji_light":@"\U0000b09d",\
@"evaluate":@"\U0000c04a",\
@"evaluate_fill":@"\U0000c04b",\
@"exit":@"\U0000f33a",\
@"explore":@"\U0000b36a",\
@"explore_fill":@"\U0000b36b",\
@"expressman":@"\U0000f40a",\
@"favor":@"\U0000b01a",\
@"favor_fill":@"\U0000b01b",\
@"favor_fill_light":@"\U0000b01e",\
@"favor_light":@"\U0000b01d",\
@"female":@"\U0000b72a",\
@"file":@"\U0000b88a",\
@"filter":@"\U0000b16a",\
@"flashbuy":@"\U0000f12a",\
@"flashbuy_fill":@"\U0000f12b",\
@"flashlight_close":@"\U0000b55a",\
@"flashlight_open":@"\U0000b56a",\
@"focus":@"\U0000b80a",\
@"fold":@"\U0000d15a",\
@"footprint":@"\U0000b14a",\
@"form":@"\U0000b24a",\
@"form_favor_light":@"\U0000f47d",\
@"form_fill":@"\U0000b24b",\
@"form_fill_light":@"\U0000b24e",\
@"form_light":@"\U0000b24d",\
@"forward":@"\U0000b45a",\
@"forward_fill":@"\U0000b45b",\
@"friend":@"\U0000a17a",\
@"friend_add":@"\U0000b27a",\
@"friend_add_fill":@"\U0000b27b",\
@"friend_add_light":@"\U0000b27d",\
@"friend_famous":@"\U0000b31a",\
@"friend_favor":@"\U0000b49a",\
@"friend_fill":@"\U0000a17b",\
@"friend_light":@"\U0000a17d",\
@"friend_settings_light":@"\U0000f49d",\
@"full":@"\U0000f25a",\
@"furniture":@"\U0000f44d",\
@"game":@"\U0000b43a",\
@"global":@"\U0000f38a",\
@"global_light":@"\U0000f38d",\
@"goods":@"\U0000b39a",\
@"goods_favor":@"\U0000f19a",\
@"goods_favor_light":@"\U0000f19d",\
@"goods_fill":@"\U0000b39b",\
@"goods_hot_fill":@"\U0000f74b",\
@"goods_light":@"\U0000b39d",\
@"goods_new":@"\U0000f29a",\
@"goods_new_fill":@"\U0000f29b",\
@"goods_new_fill_light":@"\U0000f29e",\
@"goods_new_light":@"\U0000f29d",\
@"group":@"\U0000b94a",\
@"group_fill":@"\U0000b94b",\
@"group_fill_light":@"\U0000b94e",\
@"group_light":@"\U0000b94d",\
@"haodian":@"\U0000e21a",\
@"home":@"\U0000a01a",\
@"home_fill":@"\U0000a01b",\
@"home_fill_light":@"\U0000a01e",\
@"home_light":@"\U0000a01d",\
@"hot":@"\U0000b84a",\
@"hot_fill":@"\U0000b84b",\
@"hot_light":@"\U0000b84d",\
@"hua":@"\U0000e12a",\
@"info":@"\U0000d16a",\
@"info_fill":@"\U0000d16b",\
@"ju":@"\U0000e11a",\
@"juhuasuan":@"\U0000e20a",\
@"keyboard":@"\U0000b68a",\
@"keyboard_light":@"\U0000b68d",\
@"light":@"\U0000b52a",\
@"light_auto":@"\U0000b54a",\
@"light_fill":@"\U0000b52b",\
@"light_forbid":@"\U0000b53a",\
@"like":@"\U0000b17a",\
@"like_fill":@"\U0000b17b",\
@"link":@"\U0000b26a",\
@"list":@"\U0000a13a",\
@"living":@"\U0000e24a",\
@"loading":@"\U0000b11a",\
@"location":@"\U0000b03a",\
@"location_fill":@"\U0000b03b",\
@"location_light":@"\U0000b03d",\
@"lock":@"\U0000b30a",\
@"magic":@"\U0000b91a",\
@"mail":@"\U0000f26a",\
@"male":@"\U0000b71a",\
@"mall_fill_light":@"\U0000f78e",\
@"mall_light":@"\U0000f78d",\
@"mao":@"\U0000e15a",\
@"mark":@"\U0000b83a",\
@"mark_fill":@"\U0000b83b",\
@"medal":@"\U0000f28a",\
@"medal_fill":@"\U0000f28b",\
@"medal_fill_light":@"\U0000f28e",\
@"medal_light":@"\U0000f28d",\
@"message":@"\U0000a08a",\
@"message_fill":@"\U0000a08b",\
@"message_fill_light":@"\U0000a08e",\
@"message_light":@"\U0000a08d",\
@"mobile":@"\U0000b60a",\
@"mobile_fill":@"\U0000b60b",\
@"mobile_tao":@"\U0000e05a",\
@"money_bag":@"\U0000f35a",\
@"money_bag_fill":@"\U0000f35b",\
@"more":@"\U0000a06a",\
@"more_android":@"\U0000a21a",\
@"more_android_light":@"\U0000a21d",\
@"more_light":@"\U0000a06d",\
@"move":@"\U0000d19a",\
@"music_fill":@"\U0000f20b",\
@"music_forbid_fill":@"\U0000f20c",\
@"my":@"\U0000a05a",\
@"my_fill":@"\U0000a05b",\
@"my_fill_light":@"\U0000a05e",\
@"my_light":@"\U0000a05d",\
@"new":@"\U0000b70a",\
@"new_fill":@"\U0000b70b",\
@"news":@"\U0000f30a",\
@"news_fill":@"\U0000f30b",\
@"news_fill_light":@"\U0000f30e",\
@"news_hot":@"\U0000f31a",\
@"news_hot_fill":@"\U0000f31b",\
@"news_hot_fill_light":@"\U0000f31e",\
@"news_hot_light":@"\U0000f31d",\
@"news_light":@"\U0000f30d",\
@"notice":@"\U0000b63a",\
@"notice_fill":@"\U0000b63b",\
@"notice_forbid_fill":@"\U0000f45b",\
@"notification":@"\U0000b21a",\
@"notification_fill":@"\U0000b21b",\
@"notification_forbid_fill":@"\U0000b40b",\
@"oppose_fill_light":@"\U0000f73e",\
@"oppose_light":@"\U0000f73d",\
@"order":@"\U0000b20a",\
@"paint":@"\U0000b82a",\
@"paint_fill":@"\U0000b82b",\
@"pay":@"\U0000c01a",\
@"people":@"\U0000b86a",\
@"people_fill":@"\U0000b86b",\
@"people_list":@"\U0000f27a",\
@"people_list_light":@"\U0000f27d",\
@"phone":@"\U0000b05a",\
@"phone_light":@"\U0000b05d",\
@"pic":@"\U0000b25a",\
@"pic_fill":@"\U0000b25b",\
@"pic_light":@"\U0000b25d",\
@"pick":@"\U0000f46a",\
@"play_fill":@"\U0000d20b",\
@"play_forward_fill":@"\U0000d22b",\
@"post":@"\U0000d28a",\
@"present":@"\U0000b32a",\
@"present_fill":@"\U0000b32b",\
@"profile":@"\U0000a18a",\
@"profile_fill":@"\U0000a18b",\
@"profile_light":@"\U0000a18d",\
@"pull_down":@"\U0000b13a",\
@"pull_left":@"\U0000b67a",\
@"pull_right":@"\U0000b66a",\
@"pull_up":@"\U0000b12a",\
@"punch":@"\U0000b95a",\
@"punch_light":@"\U0000b95d",\
@"qi":@"\U0000e16a",\
@"qiang":@"\U0000b64a",\
@"qr_code":@"\U0000a19a",\
@"qr_code_light":@"\U0000a19d",\
@"question":@"\U0000d09a",\
@"question_fill":@"\U0000d09b",\
@"radio_box":@"\U0000d24a",\
@"radio_box_fill":@"\U0000d24b",\
@"rank":@"\U0000b69a",\
@"rank_fill":@"\U0000b69b",\
@"read":@"\U0000b90a",\
@"recharge":@"\U0000b46a",\
@"recharge_fill":@"\U0000b46b",\
@"record":@"\U0000f18a",\
@"record_fill":@"\U0000f18b",\
@"record_light":@"\U0000f18d",\
@"redpacket":@"\U0000b41a",\
@"redpacket_fill":@"\U0000b41b",\
@"refresh":@"\U0000a20a",\
@"refresh_arrow":@"\U0000d17a",\
@"refresh_light":@"\U0000a20d",\
@"refund":@"\U0000c05a",\
@"remind":@"\U0000a16a",\
@"repair":@"\U0000b87a",\
@"repair_fill":@"\U0000b87b",\
@"repeal":@"\U0000d18a",\
@"return":@"\U0000f79a",\
@"right":@"\U0000d05a",\
@"rob":@"\U0000f15a",\
@"rob_fill":@"\U0000f15b",\
@"round":@"\U0000d12a",\
@"round_add":@"\U0000d11a",\
@"round_add_fill":@"\U0000d11b",\
@"round_add_light":@"\U0000d11d",\
@"round_check":@"\U0000d02a",\
@"round_check_fill":@"\U0000d02b",\
@"round_close":@"\U0000d04a",\
@"round_close_fill":@"\U0000d04b",\
@"round_close_fill_light":@"\U0000d04e",\
@"round_close_light":@"\U0000d04d",\
@"round_comment_light":@"\U0000f48d",\
@"round_crown_fill":@"\U0000f55b",\
@"round_down":@"\U0000d25a",\
@"round_down_light":@"\U0000d25d",\
@"round_favor_fill":@"\U0000f56b",\
@"round_friend_fill":@"\U0000f57b",\
@"round_left_fill":@"\U0000d29b",\
@"round_light_fill":@"\U0000f59b",\
@"round_like_fill":@"\U0000f58b",\
@"round_link_fill":@"\U0000f60b",\
@"round_list_light":@"\U0000f51d",\
@"round_location_fill":@"\U0000f61b",\
@"round_menu_fill":@"\U0000f63b",\
@"round_pay":@"\U0000f62a",\
@"round_pay_fill":@"\U0000f62b",\
@"round_people_fill":@"\U0000f64b",\
@"round_rank_fill":@"\U0000f65b",\
@"round_record_fill":@"\U0000f68b",\
@"round_redpacket":@"\U0000f66a",\
@"round_redpacket_fill":@"\U0000f66b",\
@"round_right":@"\U0000d06a",\
@"round_right_fill":@"\U0000d06b",\
@"round_shop_fill":@"\U0000f72b",\
@"round_skin_fill":@"\U0000f67b",\
@"round_text_fill":@"\U0000f69b",\
@"round_ticket":@"\U0000f70a",\
@"round_ticket_fill":@"\U0000f70b",\
@"round_transfer":@"\U0000f71a",\
@"round_transfer_fill":@"\U0000f71b",\
@"safe":@"\U0000f01a",\
@"same":@"\U0000b19a",\
@"same_fill":@"\U0000b19b",\
@"scan":@"\U0000a10a",\
@"scan_light":@"\U0000a10d",\
@"search":@"\U0000b07a",\
@"search_light":@"\U0000b07d",\
@"search_list":@"\U0000b57a",\
@"search_list_light":@"\U0000b57d",\
@"selection":@"\U0000b34a",\
@"selection_fill":@"\U0000b34b",\
@"send":@"\U0000c02a",\
@"service":@"\U0000b58a",\
@"service_fill":@"\U0000b58b",\
@"service_light":@"\U0000b58d",\
@"settings":@"\U0000a11a",\
@"settings_light":@"\U0000a11d",\
@"shake":@"\U0000b96a",\
@"share":@"\U0000a12a",\
@"share_light":@"\U0000a12d",\
@"shop":@"\U0000c08a",\
@"shop_fill":@"\U0000c08b",\
@"shop_light":@"\U0000c08d",\
@"similar":@"\U0000b42a",\
@"skin":@"\U0000f34a",\
@"skin_fill":@"\U0000f34b",\
@"skin_light":@"\U0000f34d",\
@"sort":@"\U0000a15a",\
@"sort_light":@"\U0000a15d",\
@"sound":@"\U0000f06a",\
@"sound_light":@"\U0000f06d",\
@"sponsor":@"\U0000f05a",\
@"sponsor_fill":@"\U0000f05b",\
@"sports":@"\U0000f41d",\
@"square":@"\U0000d13a",\
@"square_check":@"\U0000d14a",\
@"square_check_fill":@"\U0000d14b",\
@"stop":@"\U0000d21a",\
@"suan":@"\U0000e13a",\
@"subscription":@"\U0000f37b",\
@"subscription_light":@"\U0000f37d",\
@"subtitle_block_light":@"\U0000f52d",\
@"subtitle_unblock_light":@"\U0000f53d",\
@"tag":@"\U0000b23a",\
@"tag_fill":@"\U0000b23b",\
@"tao":@"\U0000e06a",\
@"taoqianggou":@"\U0000e19a",\
@"taoxiaopu":@"\U0000e10a",\
@"taxi":@"\U0000b04a",\
@"text":@"\U0000f17a",\
@"tian":@"\U0000e14a",\
@"tianmao":@"\U0000e18a",\
@"ticket":@"\U0000c07a",\
@"ticket_fill":@"\U0000c07b",\
@"ticket_money_fill":@"\U0000f75b",\
@"time":@"\U0000b02a",\
@"time_fill":@"\U0000b02b",\
@"tmall":@"\U0000e03a",\
@"top":@"\U0000b15a",\
@"triangle_down_fill":@"\U0000d31b",\
@"triangle_up_fill":@"\U0000d30b",\
@"unfold":@"\U0000d07a",\
@"unlock":@"\U0000b29a",\
@"up_block":@"\U0000f04a",\
@"upload":@"\U0000d26a",\
@"upstage":@"\U0000b61a",\
@"upstage_fill":@"\U0000b61b",\
@"usefull":@"\U0000f36a",\
@"usefull_fill":@"\U0000f36b",\
@"video":@"\U0000b98a",\
@"video_fill":@"\U0000b98b",\
@"video_fill_light":@"\U0000b98e",\
@"video_light":@"\U0000b98d",\
@"vip":@"\U0000b38a",\
@"vip_code_light":@"\U0000f54d",\
@"vipcard":@"\U0000b47a",\
@"voice":@"\U0000b48a",\
@"voice_fill":@"\U0000b48b",\
@"voice_light":@"\U0000b48d",\
@"wang":@"\U0000c06a",\
@"wang_fill":@"\U0000c06b",\
@"wang_light":@"\U0000c06d",\
@"warn":@"\U0000d08a",\
@"warn_fill":@"\U0000d08b",\
@"warn_light":@"\U0000d08d",\
@"we":@"\U0000a02a",\
@"we_block":@"\U0000f03a",\
@"we_fill":@"\U0000a02b",\
@"we_fill_light":@"\U0000a02e",\
@"we_light":@"\U0000a02d",\
@"we_unblock":@"\U0000f02a",\
@"weibo":@"\U0000e01a",\
@"wifi":@"\U0000b50a",\
@"write":@"\U0000b97a",\
@"write_fill":@"\U0000b97b",\
@"xiami":@"\U0000e22a",\
@"xiami_forbid":@"\U0000e22c",\
@"xiaoheiqun":@"\U0000f77a",\
@"ye":@"\U0000e17a",\
@"broadcast_fill":@"\U0000f80b",\
}

#define kDefaultFontColor     [UIColor colorWithRed:0x5f/255.0 green:0x64/255.0 blue:0x6e/255.0 alpha:1.0]

@implementation TBIconFont

#pragma mark - Public  Method
+ (UIFont*)iconFontWithSize:(NSInteger)fontSize{
    UIFont *iconfont = nil;
    if (fontSize > 0 ) {
        iconfont = [UIFont fontWithName:@"taobao" size: fontSize];
    }
    
    if (!iconfont) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"iconfont" ofType:@"ttf"];
            [UIFont tbfont_registerFontWithFilePath:path completionHandler:nil];
        });
        iconfont = [UIFont fontWithName:@"taobao" size: fontSize];
    }
    return iconfont;
}


+ (UIButton*)iconFontButtonWithType:(UIButtonType)type fontSize:(NSInteger)fontSize text:(NSString*)text{
    text = [[self iconfontMapDict] objectForKey:text] ? [[self iconfontMapDict] objectForKey:text] : text;
    UIButton *button = [UIButton buttonWithType:type];
    [button setTitleColor:kDefaultFontColor forState:UIControlStateNormal];
    [button setTitleColor:kDefaultFontColor forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[TBIconFont iconFontWithSize:fontSize]];
    [button setTitle:text forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    return button;
}

+ (UILabel*)iconFontLabelWithFrame:(CGRect)frame fontSize:(NSInteger)fontSize text:(NSString*)text{
    text = [[self iconfontMapDict] objectForKey:text] ? [[self iconfontMapDict] objectForKey:text] : text;
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [TBIconFont iconFontWithSize:fontSize];
    label.textColor = kDefaultFontColor;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (NSString*)iconFontUnicodeWithName:(NSString*)name{
    NSString *result = nil;
    if ([name length] >0) {
        result =  [[self iconfontMapDict] objectForKey:name];
    }
    result = result ? result : name;
    return result;
}

//////////////////////////////////////////////////////////////////////////////////
+ (NSDictionary*)iconfontMapDict {
    static NSDictionary*   gIconFontDic = nil;
    static dispatch_once_t gIconFontToken;
    dispatch_once(&gIconFontToken, ^{
        if (gIconFontDic == nil) {
            gIconFontDic = TBIconFontMap_TAOBAO;
        }
    });
    return gIconFontDic;
}

@end
