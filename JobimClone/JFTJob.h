//
//  JFTJob.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface JFTJob : NSObject
@property NSString *ID;
@property NSString *BranchName;
@property NSString *CompanyName;
@property NSString *Description;
@property UIImage *Image;
@property CLLocation *Location;
@property NSString *LiteralLocation;
@property NSString *Title;
@property NSString *Type;
@property NSString *Summary;
-(instancetype)init;
-(instancetype)initWithCompanyName: (NSString *)company andWithBranchName: (NSString *)branch andWithDescription: (NSString *)description andWithImage: (NSString *)imageString andWithLocation: (CLLocation *)location andwithTitle: (NSString *)title andWithType: (NSString *)type andWithID: (NSString *)ID andWithSummary: (NSString *)summary;
+(JFTJob *)GetLocalJob;
+(void)setLocalJob: (JFTJob *)job;
+(void)removeLocalJob;
@end
