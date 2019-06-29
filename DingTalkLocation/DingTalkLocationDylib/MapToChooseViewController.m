//
//  MapToChooseViewController.m
//  DingTalkLocationDylib
//
//  Created by 佳哥无敌啦 on 2019/6/29.
//  Copyright © 2019 佳哥无敌啦. All rights reserved.
//

#import "MapToChooseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SCLAlertView.h"

@interface MapToChooseViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) MAAnnotationView *currentChooseAnnotation;

@end

@implementation MapToChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
}

#pragma mark - Map Delegate

- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = coordinate;
    a1.title      = [NSString stringWithFormat:@"当前定位点"];
    
    [self.mapView addAnnotation:a1];
    
    if (self.chooseCoordinate) {
//        CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(coordinate, AMapCoordinateTypeGPS);

        self.chooseCoordinate(coordinate);
    }
}

/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                     = MAPinAnnotationColorGreen;
        
        return annotationView;
    }
    
    return nil;
}

/*!
 @brief 当mapView新添加annotation views时调用此接口
 @param mapView 地图View
 @param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
}

/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param view 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"当前经度:%@，维度:%@", @(view.annotation.coordinate.longitude), @(view.annotation.coordinate.latitude));
}

/*!
 @brief 当取消选中一个annotation views时调用此接口
 @param mapView 地图View
 @param view 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    
}

/*!
 @brief 标注view的accessory view(必须继承自UIControl)被点击时调用此接口
 @param mapView 地图View
 @param view callout所属的标注view
 @param control 对应的control
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

/**
 *  标注view的calloutview整体点击时调用此接口
 *
 *  @param mapView 地图的view
 *  @param view calloutView所属的annotationView
 */
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"定位该地址" actionBlock:^(void) {
        if (self.chooseCoordinate) {
//            CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(view.annotation.coordinate, AMapCoordinateTypeGPS);

            self.chooseCoordinate(view.annotation.coordinate);
        }
    }];
    [alert showInfo:self title:@"定位" subTitle:@"好好上班，不要迟到早退" closeButtonTitle:@"什么也不做" duration:0.f];
}

/*!
 @brief 拖动annotation view时view的状态变化，ios3.2以后支持
 @param mapView 地图View
 @param view annotation view
 @param newState 新状态
 @param oldState 旧状态
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
