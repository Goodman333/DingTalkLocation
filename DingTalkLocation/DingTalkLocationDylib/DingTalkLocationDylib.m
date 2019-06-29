//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  DingTalkLocationDylib.m
//  DingTalkLocationDylib
//
//  Created by 佳哥无敌啦 on 2019/6/29.
//  Copyright (c) 2019 佳哥无敌啦. All rights reserved.
//

#import "DingTalkLocationDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import <CoreLocation/CoreLocation.h>
#import <MDSettingCenter/MDSettingsViewController.h>
#import "MapToChooseViewController.h"

@implementation CoordinateForm

- (NSArray *)fields
{
    return @[
             @{FXFormFieldTitle:@"地图选点",
               FXFormFieldHeader:@"修改定位",
               FXFormFieldAction:@"chooseCoordinate"
               },
             ];
}

@end

CLLocation *location;

CHConstructor{
    printf(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        location = [[CLLocation alloc]initWithLatitude:39.97020534939236 longitude:116.4889675564236];
        
        MDSuspendBall *ball = [MDSuspendBall sharedInstance];
        [ball addToWindow:[UIApplication sharedApplication].keyWindow];
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}

CHDeclareClass(MDSettingsViewController)

// 设置fxform
CHOptimizedMethod0(self, void, MDSettingsViewController, setupSubViews){
    CHSuper0(MDSettingsViewController, setupSubViews);
    FXFormController *controller = [self valueForKeyPath:@"formController"];
    controller.form = [[CoordinateForm alloc]init];
}

CHDeclareMethod0(void, MDSettingsViewController, chooseCoordinate) {
    MapToChooseViewController *chooseController = [[MapToChooseViewController alloc]init];
    chooseController.chooseCoordinate = ^(CLLocationCoordinate2D coordinate) {
        NSLog(@"转换后经度:%@，维度:%@", @(coordinate.longitude), @(coordinate.latitude));

        location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    };
    [self.navigationController pushViewController:chooseController animated:YES];
}

CHConstructor{
    CHLoadLateClass(MDSettingsViewController);
    CHHook0(MDSettingsViewController, setupSubViews);
}

CHDeclareClass(AMapLocationCLMDelegate)

CHOptimizedMethod2(self, void, AMapLocationCLMDelegate, locationManager, id, arg1, didUpdateLocations, id, arg2) {
    
    CHSuper2(AMapLocationCLMDelegate, locationManager, arg1, didUpdateLocations, @[location]);
}

CHConstructor {
    CHLoadLateClass(AMapLocationCLMDelegate);
    CHHook2(AMapLocationCLMDelegate, locationManager, didUpdateLocations);
}
