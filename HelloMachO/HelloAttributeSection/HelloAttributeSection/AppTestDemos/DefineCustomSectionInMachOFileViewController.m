//
//  DefineCustomSectionInMachOFileViewController.m
//  HelloAttributeSection
//
//  Created by wesley_chen on 2018/6/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DefineCustomSectionInMachOFileViewController.h"

#define WCURLRouterDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))


/**
 注册路由URL处理类
 
 注册ViewController
 @example WCURLRouterRegisterURLHandler(LTaoTestViewController, NO, Debug, 'm.ltao.com/debug | m.ltao.com/test', );
 
 注册单例Resolver
 @example WCURLRouterRegisterURLHandler(LTaoSettingURLResolver, YES, LTaoMy, 'm.ltao.com/my/setting', );
 
 注册正则
 @example WCURLRouterRegisterURLHandler(XXXHandler, NO, XXXBundle, 'main/first | main/second', '^.*taobao | ^.*tbcdn')
 
 @param handlerClass URL处理类
 @param isSingleton 是否单例，YES或NO，如果是YES,且handlerClass有+[sharedInstance]方法，则会调用+[sharedInstance]方法来获取单例。强烈建议单例的自己实现+[sharedInstance]方法。
 @param bundleName bundle名
 @param urls 能处理的url，用单引号包围，多个url用" | "分割，示例：'main/first | main/second'
 @param urlRegexes 能处理的url匹配正则，规则通urls，示例：'^.*taobao | ^.*tbcdn'
 */
#define WCURLRouterRegisterURLHandler(handlerClass,isSingleton,bundleName,urls,urlRegexes) \
char * k##handlerClass##_router WCURLRouterDATA(WCURLRouterSec) = "{ \"handler\" : \""#handlerClass"\", \"singleton\" : \""#isSingleton"\", \"bundle\" : \""#bundleName"\", \"urls\" : \""#urls"\", \"urlRegexes\" : \""#urlRegexes"\", \"type\" : \"URLHandler\"}";

WCURLRouterRegisterURLHandler(LTaoWangxinUrlHandler, NO, LTaoWangxin, 'h5.wapa.taobao.com/ww/index.htm | m.ltao.com/wangxin/p2pchat | im.m.taobao.com/ww/ad_ww_dialog.htm | h5.m.taobao.com/ww/index.htm | m.ltao.com/wangxin/convlist',)

// @see https://stackoverflow.com/a/22366882
extern int start_mysection __asm("section$start$__DATA$__mysection");
extern int stop_mysection  __asm("section$end$__DATA$__mysection");

// If you don't reference x, y and z explicitly, they'll be dead-stripped.
// Prevent that with the "used" attribute.
static int x __attribute__((used,section("__DATA,__mysection"))) = 4;
static int y __attribute__((used,section("__DATA,__mysection"))) = 10;
static int z __attribute__((used,section("__DATA,__mysection"))) = 22;


extern char* start_mysection2 __asm("section$start$__DATA$__mysection2");
extern char* stop_mysection2  __asm("section$end$__DATA$__mysection2");
static char *str1 __attribute__((used,section("__DATA,__mysection2"))) = "str1";
static char *str2 __attribute__((used,section("__DATA,__mysection2"))) = "str2";

@interface DefineCustomSectionInMachOFileViewController ()

@end

@implementation DefineCustomSectionInMachOFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    [self test2];
}

- (void)test1 {
    long sz = &stop_mysection - &start_mysection;
    long i;
    
    printf("Section size is %ld\n", sz);
    
    for (i=0; i < sz; ++i) {
        printf("%d\n", (&start_mysection)[i]);
    }
}

- (void)test2 {
    long sz = &stop_mysection2 - &start_mysection2;
    long i;
    
    printf("Section size is %ld\n", sz);
    
    for (i=0; i < sz; ++i) {
        printf("%s\n", (&start_mysection2)[i]);
    }
}

@end
