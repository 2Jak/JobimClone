//
//  JFTImageChaceStore.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTImageCacheStore.h"
#import "JFTJobTypeStore.h"
@interface JFTImageCacheStore()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end
@implementation JFTImageCacheStore
+(instancetype)sharedStore
{
    static JFTImageCacheStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}
#pragma mark - Constructors
-(instancetype)init
{
    @throw [NSException exceptionWithName: @"SingletonOnly" reason: @"This is a singleton object, please use the [JFTImageCacheStore sharedStore]" userInfo: nil];
    return nil;
}
-(instancetype)initPrivate
{
    if (self = [super init])
    {
        _dictionary = [NSMutableDictionary new];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver: self selector: @selector(clearChace:) name: UIApplicationDidReceiveMemoryWarningNotification object: nil];
        [self loadLocalImages];
    }
    return  self;
}
#pragma mark - Getters
-(UIImage*)imageForKey: (NSString*)key
{
    UIImage* result = self.dictionary[key];
    if (!result)
        return [UIImage imageNamed: @"noImageImage" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
    return result;
}
#pragma mark - Data Controls
-(void)deleteImageForKey: (NSString*)key
{
    if (!key)
        return;
    [self.dictionary removeObjectForKey: key];
}
-(void)clearChace: (NSNotification*)note
{
    [self.dictionary removeAllObjects];
}
-(void)loadLocalImages
{
    NSMutableArray *result = [NSMutableArray array];
    [result addObject: @"OpenTableViewIcon"];
    [result addObject: @"OpenMenuIcon"];
    [result addObject: @"LocationIcon"];
    [[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil] enumerateObjectsUsingBlock: ^(NSString *obj, NSUInteger idx, BOOL *stop)
    {
        NSString *path = [[obj lastPathComponent] stringByDeletingPathExtension];;
        if ([path containsString: @"JobTypeIcon"] == YES || [path containsString: @"JobMapPin"] == YES || [path containsString: @"Button"] == YES)
        {
            [result addObject: path];
        }
        for (NSString* imageFileName in result)
        {
            UIImage* newImage = [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", imageFileName] inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
            [self.dictionary setObject: newImage forKey: imageFileName];
        }
    }];
}
@end
