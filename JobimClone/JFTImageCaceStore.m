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
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"SingletonOnly" reason:@"This is a singleton object, please use the [JFTImageCacheStore sharedStore]" userInfo:nil];
    return nil;
}
-(instancetype)initPrivate
{
    if (self = [super init])
    {
        _dictionary = [NSMutableDictionary new];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearChace:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return  self;
}
-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    NSString *imgPath = [self imagePathForKey:key];
    NSData 	*imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:imgPath atomically:YES];
}
-(UIImage *)imageForKey:(NSString *)key
{
    UIImage *result =self.dictionary[key];
    if (!result)
    {
        NSString *imgPath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imgPath];
        if(result)
            self.dictionary[key] = result;
        else
            NSLog(@"Error 404! File not found!");
    }
    return self.dictionary[key];
}
-(void)deleteImageForKey:(NSString *)key
{
    if (!key)
        return;
    [self.dictionary removeObjectForKey:key];
    NSString *imgPath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
}
-(NSString *)imagePathForKey: (NSString *)key
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [directories firstObject];
    return [directory stringByAppendingString:key];
}

-(void)clearChace:(NSNotification *)note
{
    [self.dictionary removeAllObjects];
}
-(void)loadLocalImages
{
    NSMutableArray *imageKeys = [[[JFTJobTypeStore sharedStore] AllItems] copy];
    [imageKeys addObjectsFromArray:@[]];
    for (NSString *key in imageKeys)
         [self loadImageForKey:key];
}
-(void)loadImageForKey: (NSString *)key
{
    UIImage *result =self.dictionary[key];
    if (!result)
    {
        NSString *imgPath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imgPath];
        if(result)
            self.dictionary[key] = result;
        else
            NSLog(@"Error 404! File not found!");
    }
}
@end
