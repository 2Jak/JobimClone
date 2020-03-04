//
//  JFTLocalJobsStore.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTLocalJobsStore.h"
#import "JFTJob.h"
#import "JFTImageCacheStore.h"
#import <CoreLocation/CoreLocation.h>
@interface JFTLocalJobsStore()
@property (nonatomic) NSMutableArray *privateItems;
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
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"SingletonOnly" reason:@"This is a singleton object, please use the [JFTLocalJobsStore sharedStore]" userInfo:nil];
}
-(instancetype)initPrivate
{
    if (self = [super init])
    {
        [self loaData];
        if(!self.privateItems)
            self.privateItems = [NSMutableArray new];
    }
    return self;
}
-(NSArray *)AllItems
{
    return self.privateItems;
}
-(void)addItem
{
    [self.privateItems addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"LocalJob"]];
}
-(void)removeItem:(JFTJob *)job
{
    [self.privateItems removeObjectIdenticalTo:job];
}
-(BOOL)saveData
{
    //FireBase Update
    return NO;
}

-(void)loaData
{
    NSArray *allJobsArray =  @[]; //FireBase Load
    for (JFTJob *job in allJobsArray)
    {
        CLLocation *currentLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalLocation"];
        if ([currentLocation distanceFromLocation:job.Location] <= 2000.0)
            [self.privateItems addObject:job];
    }
}
@end
