//
//  JFTPersonalInfoVwCtrl.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JFTUser;
@interface JFTPersonalInfoVwCtrl : UITabBarController
@property (nonatomic) BOOL isRegistrationPage;
-(void)asRegistrationPage;
@end

NS_ASSUME_NONNULL_END
