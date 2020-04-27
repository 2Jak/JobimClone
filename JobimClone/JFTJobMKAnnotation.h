//
//  JFTJobMKAnnotation.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 23/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JFTJobMKAnnotation : NSObject
<MKAnnotation>
-(id)initWithJobTitle:(NSString*)title jobType:(NSString*)type coordinate:(CLLocationCoordinate2D)coordinate andJobID: (NSString*)jobID;
-(NSString*)jobID;
-(MKMapItem*)mapItem;
@end

NS_ASSUME_NONNULL_END
