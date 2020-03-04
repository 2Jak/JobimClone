//
//  Utilities.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface JFTUtilities : NSObject
+(NSString *)addressFromLocation: (CLLocation *)location;
@end
