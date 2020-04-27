//
//  JFTJobTypeStore.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTJobTypeStore.h"
@interface JFTJobTypeStore()
@property (nonatomic, strong) NSMutableDictionary* jobTypeToColor;
@property (nonatomic, strong) NSMutableArray* privateItems;
@end
@implementation JFTJobTypeStore
+(instancetype)sharedStore
{
    static JFTJobTypeStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}
#pragma mark - Constructors
-(instancetype)init
{
    @throw [NSException exceptionWithName: @"SingletonOnly" reason: @"This is a singleton object, please use the [JFTItemStore sharedStore]" userInfo: nil];
}
-(instancetype)initPrivate
{
    if (self = [super init])
    {
        if(!self.privateItems)
        {
            self.privateItems = [NSMutableArray new];
            [self.privateItems addObject:@"Storage"];
            [self.privateItems addObject:@"Restaurant"];
            [self.privateItems addObject:@"Office"];
            [self.privateItems addObject:@"Security"];
            [self.privateItems addObject:@"Cook"];
            [self.privateItems addObject:@"Driver"];
        }
        if(!self.jobTypeToColor)
        {
            self.jobTypeToColor = [NSMutableDictionary new];
            [self.jobTypeToColor setObject: [UIColor colorWithRed: 0.996f green: 0.769f blue: 0.109f alpha: 1] forKey: @"Cook"];
            [self.jobTypeToColor setObject: [UIColor colorWithRed: 134 green: 117 blue: 120 alpha: 1] forKey: @"Driver"];
            [self.jobTypeToColor setObject: [UIColor colorWithRed: 74 green: 103 blue: 150 alpha: 1] forKey: @"Office"];
            [self.jobTypeToColor setObject: [UIColor colorWithRed: 183 green: 100 blue: 146 alpha: 1] forKey: @"Restaurant"];
            [self.jobTypeToColor setObject: [UIColor colorWithRed: 96 green: 92 blue: 130 alpha: 1] forKey: @"Security"];
            [self.jobTypeToColor setObject: [UIColor colorWithRed: 143 green: 147 blue: 135 alpha: 1] forKey: @"Storage"];
        }
    }
    return self;
}
#pragma mark - Getters
-(NSArray *)AllItems
{
    return self.privateItems;
}
-(UIColor*)getColorForJobType: (NSString*)type
{
    return self.jobTypeToColor[type];
}
@end
