//
//  MapToChooseViewController.h
//  DingTalkLocationDylib
//
//  Created by 佳哥无敌啦 on 2019/6/29.
//  Copyright © 2019 佳哥无敌啦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseCoordinate)(CLLocationCoordinate2D coordinate);

@interface MapToChooseViewController : UIViewController

@property (nonatomic, copy) ChooseCoordinate chooseCoordinate;

@end

NS_ASSUME_NONNULL_END
