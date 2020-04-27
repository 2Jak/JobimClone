//
//  JFTJobLocationVwCtrl.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface JFTJobLocationVwCtrl : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *jobAddressSrchBr;
@property (weak, nonatomic) IBOutlet MKMapView *jobLocationMpVw;
@end

NS_ASSUME_NONNULL_END
