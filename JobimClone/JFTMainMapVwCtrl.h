//
//  JFTMainMapVwCtrl.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 23/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JFTMainMapVwCtrl : UIViewController
@property (weak, nonatomic) IBOutlet UIButton* centerMapButton;
@property (weak, nonatomic) IBOutlet MKMapView* mainMapView;
@end

NS_ASSUME_NONNULL_END
