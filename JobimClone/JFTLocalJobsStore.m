//
//  JFTLocalJobsStore.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "JFTImageCacheStore.h"
#import "JFTLocalJobsStore.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTLocalJobsStore()
@property (nonatomic) NSMutableArray* privateDisplayedJobs;
@property (nonatomic) NSMutableArray* privateFavouriteJobs;
@property (nonatomic) NSMutableDictionary* userCreatedJobs;
@property (nonatomic) NSMutableDictionary* blacklist;
@property (nonatomic) NSMutableArray* privateJobs;
@end
@implementation JFTLocalJobsStore
+(instancetype)sharedStore
{
    static JFTLocalJobsStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}
#pragma mark - Constructors
-(instancetype)init
{
    @throw [NSException exceptionWithName: @"SingletonOnly" reason: @"This is a singleton object, please use the [JFTLocalJobsStore sharedStore]" userInfo: nil];
}
-(instancetype)initPrivate
{
    if (self = [super init])
    {
        if(!self.privateJobs)
            self.privateJobs = [NSMutableArray new];
        if(!self.privateDisplayedJobs)
            self.privateDisplayedJobs = [NSMutableArray new];
        if(!self.privateFavouriteJobs)
            self.privateFavouriteJobs = [NSMutableArray new];
        if(!self.blacklist)
            self.blacklist = [NSMutableDictionary new];
        if(!self.userCreatedJobs)
            self.userCreatedJobs = [NSMutableDictionary new];
        if ([[NSUserDefaults standardUserDefaults] objectForKey: @"UserBlacklist"] == nil)
        {
            [self saveData];
        }
        [self loaData];
    }
    return self;
}
#pragma mark - Getters
-(NSArray*)AllJobs
{
    return self.privateJobs;
}
-(NSArray*)DisplayedJobs
{
    return self.privateDisplayedJobs;
}
-(NSArray*)FavouriteJobs
{
    return self.privateFavouriteJobs;
}
#pragma mark - Data Controls
-(void)addLocalJob
{
    NSString* key = [[[JFTUtilities globalDatabaseReference] child:@"jobs"] childByAutoId].key;
    LocalJob.ID = [key copy];
    NSDictionary* jobServerPacket = @{[@"/jobs/" stringByAppendingString: key]:[JFTJob JSONFromJob: LocalJob]};
    [self.privateJobs addObject: [LocalJob copy]];
    [[JFTUtilities globalDatabaseReference] updateChildValues: jobServerPacket withCompletionBlock: ^(NSError* _Nullable error, FIRDatabaseReference* _Nonnull ref)
    {
        if (!error)
        {
            [self.userCreatedJobs setObject: @YES forKey: [LocalJob.ID copy]];
            [self.privateFavouriteJobs addObject: [LocalJob.ID copy]];
            LocalJob = [JFTJob new];
            [self saveData];
            [self cleanErrorsFromFavourites: self.privateJobs];
        }
        else
        {
            [self.privateJobs removeLastObject];
            [self cleanErrorsFromFavourites: self.privateJobs];
        }
    }];
}
-(void)removeJobByID: (NSString*)jobID
{
    JFTJob* selectedJob = [self getJobByID: jobID];
    if (self.userCreatedJobs[jobID] != nil)
    {
        [self.privateJobs removeObject: selectedJob];
        [self.userCreatedJobs removeObjectForKey: jobID];
        [self removeFromFavourites: jobID];
        [self removeJobFromDatabase: selectedJob];
    }
}
-(void)blacklistAJob: (NSString*)jobID
{
    [self.blacklist setObject: @YES forKey: jobID];
    [self.privateDisplayedJobs removeObjectAtIndex: [self indexOfStringThatEqualsTo: jobID inArray: self.privateDisplayedJobs]];
    [[NSUserDefaults standardUserDefaults] setObject: self.blacklist forKey: @"UserBlackList"];
}
-(BOOL)saveData
{
    [[NSUserDefaults standardUserDefaults] setObject: self.blacklist forKey: @"UserBlacklist"];
    [[NSUserDefaults standardUserDefaults] setObject: self.userCreatedJobs forKey: @"UserCreatedJobs"];
    [[NSUserDefaults standardUserDefaults] setObject: self.privateFavouriteJobs forKey: @"UserFavourites"];
    return YES;
}
-(void)loaData
{
    self.blacklist = [NSMutableDictionary dictionaryWithDictionary: [[NSUserDefaults standardUserDefaults] objectForKey: @"UserBlacklist"]];
    self.userCreatedJobs = [NSMutableDictionary dictionaryWithDictionary: [[NSUserDefaults standardUserDefaults] objectForKey: @"UserCreatedJobs"]];
    self.privateFavouriteJobs = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey: @"UserFavourites"]];
    [[[JFTUtilities globalDatabaseReference] child: @"jobs"] observeEventType: FIRDataEventTypeValue withBlock: ^(FIRDataSnapshot* _Nonnull snapshot)
    {
        for (FIRDataSnapshot* dbJob in snapshot.children)
        {
            if ([self getJobByID: dbJob.key] == nil)
            {
                JFTJob* job = [JFTJob jobFromJSON: dbJob.value andWithID: dbJob.key];
                if ([job.LiteralLocation isEqualToString: @""] == YES)
                    [JFTUtilities addressFromLocation: job.Location andSender: job];
                [self.privateJobs addObject: job];
            }
        }
        [self filterDisplayedJobs: JFTFilterJobsByNone forValue: nil];
    }];
}
-(JFTJob*)getJobByID: (NSString*)ID
{
    for (JFTJob* job in self.AllJobs)
        if ([job.ID  isEqualToString: ID])
            return job;
    NSLog(@"404 Job Not Found!");
    return nil;
}
-(void)addToFavourites: (NSString*)jobID
{
    if ([self indexOfStringThatEqualsTo: jobID inArray: self.privateFavouriteJobs] != -1)
        return;
    else
        [self.privateFavouriteJobs addObject: [jobID copy]];
    [[NSUserDefaults standardUserDefaults] setObject: self.privateFavouriteJobs forKey: @"UserFavourites"];
}
-(void)removeFromFavourites: (NSString*)jobID
{
    [self.privateFavouriteJobs removeObjectAtIndex: [self indexOfStringThatEqualsTo: jobID inArray: self.privateFavouriteJobs]];
    [[NSUserDefaults standardUserDefaults] setObject: self.privateFavouriteJobs forKey: @"UserFavourites"];
}
-(void)filterDisplayedJobs: (JFTFilterParameter)parameter forValue: (NSArray*)values
{
    [self.privateDisplayedJobs removeAllObjects];
    switch (parameter)
    {
        case JFTFilterJobsByJobType:
            for (JFTJob* job in self.privateJobs)
                for (NSString* value in values)
                    if ([job.Type isEqualToString: value])
                        [self.privateDisplayedJobs addObject: job.ID];
            break;
        case JFTFilterJobsByLocation:
            for (JFTJob* job in self.privateJobs)
                if ([job.LiteralLocation containsString: values[0]])
                    [self.privateDisplayedJobs addObject: job.ID];
            break;
        case JFTFilterJobsByCompanyName:
            for (JFTJob* job in self.privateJobs)
                if ([job.CompanyName containsString: values[0]])
                    [self.privateDisplayedJobs addObject: job.ID];
            break;
        default:
            for (JFTJob* job in self.privateJobs)
                if (self.blacklist[job.ID] == nil)
                    [self.privateDisplayedJobs addObject: job.ID];
            break;
    }
}
#pragma mark - Helper Methods
-(void)removeJobFromDatabase: (JFTJob*)job
{
    [[[[JFTUtilities globalDatabaseReference] child: @"jobs"] child: job.ID] removeValueWithCompletionBlock: ^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref)
    {
        if (error)
        {
          NSLog(@"Data could not be saved: %@", error);
        }
    }];
}
-(void)cleanErrorsFromFavourites: (NSArray*)jobs
{
    NSMutableDictionary* countIDs = [NSMutableDictionary new];
    NSMutableArray* toRemove = [NSMutableArray new];
    for (JFTJob* job in jobs)
        for (int i = 0; i < self.privateFavouriteJobs.count; i++)
            if ([self.privateFavouriteJobs[i] isEqualToString: job.ID])
            {
                NSString* indexString = [NSString stringWithFormat: @"%d", i];
                countIDs[indexString] = [NSNumber numberWithInt: ([countIDs[indexString] intValue] + 1)];
            }
            else
            {
                NSString* indexString = [NSString stringWithFormat: @"%d", i];
                countIDs[indexString] = [NSNumber numberWithInt: 0];
            }
    for (NSString* key in countIDs)
        if ([countIDs[key] intValue] != 1)
            [toRemove addObject: self.privateFavouriteJobs[[countIDs[key] intValue]]];
    countIDs = nil;
    for (NSString* jobID in toRemove)
         [self.privateFavouriteJobs removeObject: jobID];
    [[NSUserDefaults standardUserDefaults] setObject: self.privateFavouriteJobs forKey: @"UserFavourites"];
}
-(int)indexOfStringThatEqualsTo: (NSString*)searchValue inArray: (NSMutableArray*)searchInArray
{
    for (NSString* string in searchInArray)
        if ([searchValue isEqualToString: string])
            return (int)[searchInArray indexOfObject: string];
    return -1;
}
-(BOOL)isUserCreatedJob: (NSString*)jobID
{
    if ((int)self.userCreatedJobs.count != 0)
        for (NSString* userCreatedJobID in self.userCreatedJobs)
            if ([userCreatedJobID isEqualToString: jobID])
                return YES;
    return NO;
}
@end
