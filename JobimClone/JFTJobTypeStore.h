//
//  JFTJobTypeStore.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JFTJobTypeStore : NSObject
@property (nonatomic, readonly) NSArray *AllItems;
+(instancetype)sharedStore;
-(UIColor*)getColorForJobType: (NSString*)type;
@end
