//
//  FSLocationManager.m
//  RWHNewton
//
//  Created by 翁志方 on 2016/12/27.
//  Copyright © 2016年 RWH. All rights reserved.
//

#import "FYLocationManager.h"
#import <UIKit/UIKit.h>
#import "FYHeader.h"
#import "FYWGS84TOGCJ02.h"
@interface FYLocationManager()<UIAlertViewDelegate>

@end

@implementation FYLocationManager

+ (instancetype)shareInstance
{
    static FYLocationManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [FYLocationManager new];
        obj.locationEnalbe =NO;
        
    });
    return obj;
}


-(BOOL)locationEnalbe{
//    _locationEnalbe = [CLLocationManager locationServicesEnabled];
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        _locationEnalbe = YES;
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        
        _locationEnalbe = NO;
    }
    
    
    if (_locationEnalbe) {
    }else{
        [UIAlertController showColorAlertInViewController:[UIViewController currentViewController] withTitle:nil message:@"无法获取你当前的位置，请去设置中打开定位开关" leftButtonTitle:@"知道了" leftBtnColor:color_text_00a0e9 rightButtonTitle:nil rightColor:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        }];
    }
    return _locationEnalbe;
}


-(void)stopLocation{
    [locationManager stopUpdatingLocation];
}
- (void)start
{
    if (!locationManager) {
        locationManager = [CLLocationManager new];
        
        //            [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [locationManager startUpdatingLocation];
//    [locationManager requestLocation];
   
}



-(void) requestLocartion{
    [locationManager stopUpdatingLocation];
    [NSObject cancelPreviousPerformRequestsWithTarget:locationManager selector:@selector(startUpdatingLocation) object:nil];
    [locationManager performSelector:@selector(startUpdatingLocation) withObject:nil afterDelay:0.5];
//    [locationManager startUpdatingHeading];

}
#pragma mark delegate

#pragma mark delegate
#pragma mark location

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}




- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
//    [locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coor = location.coordinate;
    CLLocationCoordinate2D locNew = coor;
    if (![FYWGS84TOGCJ02 isLocationOutOfChina:coor]) {
        locNew = [FYWGS84TOGCJ02 transformFromWGSToGCJ:coor];
    }
    self.latitude = locNew.latitude;
    self.lontitue = locNew.longitude;
    self.currentLocation = [[CLLocation alloc]initWithCoordinate:locNew altitude:location.altitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy timestamp:location.timestamp];
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:locNew.latitude longitude:locNew.longitude];
    
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        for (CLPlacemark *placeMark in placemarks) {
            
            
            
//            NSDictionary *addressDic = placeMark.addressDictionary;
//            
//            
//            
//            NSString *state=[addressDic objectForKey:@"State"];
//            
//            NSString *city=[addressDic objectForKey:@"City"];
//            
//            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
//            
//            NSString *street=[addressDic objectForKey:@"Street"];
//            NSLog(@"位置：%@", placeMark.name);
//            NSLog(@"国家：%@", placeMark.country);
//            NSLog(@"城市：%@", placeMark.locality);
//            NSLog(@"区：%@", placeMark.subLocality);
//            NSLog(@"街道：%@", placeMark.thoroughfare);
//            NSLog(@"子街道：%@", placeMark.subThoroughfare);
//
//            NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
            NSMutableString *address = [NSMutableString new];
//            [FYProgressHUD showToastStatus:[NSString stringWithFormat:@"%@==%@==%@==%@=="
//                                        ,placeMark.locality?:@"kong",placeMark.subLocality?:@"kong",placeMark.thoroughfare?:@"kong",placeMark.name?:@"kong"]];
            if (![NSString isEmpty:placeMark.locality]) {
                [address appendString:placeMark.locality];
            }
            if (![NSString isEmpty:placeMark.subLocality]) {
                [address appendString:placeMark.subLocality];
            }
            if (![NSString isEmpty:placeMark.thoroughfare]) {
                [address appendString:placeMark.thoroughfare];
            }
            if (![NSString isEmpty:placeMark.name]) {
                [address appendFormat:@"%@",placeMark.name];
            }
            self.areaStr = address;
            if (self.locationBlock && ![NSString isEmpty:address]) {
                self.locationBlock(address);
                break;
            }
        }
        
    }];
    
    
}






@end
