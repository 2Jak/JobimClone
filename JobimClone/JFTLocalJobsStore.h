//
//  JFTLocalJobsStore.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    JFTFilterJobsByCompanyName,
    JFTFilterJobsByLocation,
    JFTFilterJobsByJobType,
    JFTFilterJobsByNone
}JFTFilterParameter;
@class JFTJob;
@interface JFTLocalJobsStore : NSObject
@property (nonatomic, readonly) NSArray* AllJobs;
@property (nonatomic, readonly) NSArray* DisplayedJobs;
@property(nonatomic, readonly) NSArray* FavouriteJobs;
+(instancetype)sharedStore;
-(void)addLocalJob;
-(void)removeJobByID: (NSString*)jobID;
-(BOOL)saveData;
-(void)loaData;
-(void)addToFavourites: (NSString*)jobID;
-(void)removeFromFavourites: (NSString*)jobID;
-(void)blacklistAJob: (NSString*)jobID;
-(JFTJob*)getJobByID: (NSString*)ID;
-(void)filterDisplayedJobs: (JFTFilterParameter)parameter forValue: (NSArray*)values;
-(BOOL)isUserCreatedJob: (NSString*)jobID;
@end
