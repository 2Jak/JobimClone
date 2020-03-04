//
//  JFTLocalJobsStore.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JFTJob;
@interface JFTLocalJobsStore : NSObject
@property (nonatomic, readonly) NSArray *AllItems;
+(instancetype)sharedStore;
-(void)addItem;
-(void)removeItem:(JFTJob *)item;
-(BOOL)saveData;
-(void)loaData;
@end
