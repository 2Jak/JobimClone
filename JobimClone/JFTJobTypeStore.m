//
//  JFTJobTypeStore.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobTypeStore.h"
@interface JFTJobTypeStore()
@property (nonatomic) NSMutableArray *privateItems;
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
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"SingletonOnly" reason:@"This is a singleton object, please use the [JFTItemStore sharedStore]" userInfo:nil];
}
-(instancetype)initPrivate
{
    if (self = [super init])
    {
        if(!self.privateItems)
        {
            self.privateItems = [NSMutableArray new];
            [self.privateItems addObject:@"Cashier"];
            [self.privateItems addObject:@"Waiter"];
            [self.privateItems addObject:@"Inventory Manager"];
            [self.privateItems addObject:@"Store Manager"];
            [self.privateItems addObject:@"Shift Manager"];
            [self.privateItems addObject:@"Frontdesk Worker"];
            [self.privateItems addObject:@"Office Worker"];
            [self.privateItems addObject:@"Delieverer"];
            [self.privateItems addObject:@"Mover"];
            [self.privateItems addObject:@"Store Organizer"];
        }
    }
    return self;
}
-(NSArray *)AllItems
{
    return self.privateItems;
}
@end
