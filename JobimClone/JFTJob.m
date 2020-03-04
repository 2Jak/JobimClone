//
//  JFTJob.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJob.h"
#import "JFTUtilities.h"
@implementation JFTJob
-(instancetype)init
{
    if (self = [super init])
    {
        self.ID = @"";
        self.CompanyName = @"";
        self.BranchName = @"";
        self.Title = @"";
        self.Type = @"";
        self.Summary = @"";
        self.Description = @"";
        self.Image = [UIImage new];
        self.Location = [CLLocation new];
        self.LiteralLocation = @"";
    }
    return self;
}
-(instancetype)initWithCompanyName: (NSString *)company andWithBranchName: (NSString *)branch andWithDescription: (NSString *)description andWithImage: (NSString *)imageString andWithLocation: (CLLocation *)location andwithTitle: (NSString *)title andWithType: (NSString *)type andWithID:(NSString *)ID andWithSummary:(NSString *)summary
{
    if (self = [super init])
    {
        self.ID = ID;
        self.CompanyName = company;
        self.BranchName = branch;
        self.Title = title;
        self.Type = type;
        self.Summary = summary;
        self.Description = description;
        self.Image = [[UIImage alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        self.Location = location;
        self.LiteralLocation = [JFTUtilities addressFromLocation:self.Location];
    }
    return self;
}
+(JFTJob *)GetLocalJob
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalJob"];
}
+(void)setLocalJob: (JFTJob *)job
{
    [[NSUserDefaults standardUserDefaults] setObject:job forKey:@"LocalJob"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)removeLocalJob
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocalJob"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
