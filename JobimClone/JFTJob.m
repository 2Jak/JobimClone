//
//  JFTJob.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTUtilities.h"
#import "JFTJob.h"
@implementation JFTJob
-(instancetype)init
{
    if (self = [super init])
    {
        self.ID = @"";
        self.CompanyName = @"";
        self.BranchName = @"";
        self.Title = @"";
        self.Type = @"Office";
        self.Summary = @"";
        self.Description = @"";
        self.Image = [UIImage imageNamed: @"noImageImage" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
        self.Location = [LocalLocation copy];
        self.LiteralLocation = @"";
        self.PhoneNumber = @"";
        self.Email = @"";
    }
    return self;
}
-(instancetype)initWithCompanyName: (NSString *)company andWithBranchName: (NSString *)branch andWithDescription: (NSString *)description andWithImage: (NSString *)imageString andWithLocation: (CLLocation *)location andwithTitle: (NSString *)title andWithType: (NSString *)type andWithID:(NSString *)ID andWithSummary:(NSString *)summary andWithPhoneNumber:(NSString *)phoneNumber andWithEmail:(NSString *)email
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
        if (imageString)
            self.Image = [[UIImage alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        else
            self.Image = [UIImage new];
        self.LiteralLocation = @"";
        self.Location = location;
        [JFTUtilities addressFromLocation:self.Location andSender: self.LiteralLocation];
        self.PhoneNumber = phoneNumber;
        self.Email = email;
    }
    return self;
}
+(JFTJob*)jobFromJSON: (NSDictionary*)jsonData andWithID: (NSString*)jobID
{
    return [[JFTJob alloc] initWithCompanyName: [jsonData objectForKey: @"companyName"] andWithBranchName: [jsonData objectForKey: @"branchName"] andWithDescription: [jsonData objectForKey: @"description"] andWithImage: [jsonData objectForKey: @"image"] andWithLocation: [JFTUtilities locationFromJSON: [jsonData objectForKey: @"location"]] andwithTitle: [jsonData objectForKey: @"title"] andWithType: [jsonData objectForKey: @"type"] andWithID: jobID andWithSummary: [jsonData objectForKey: @"summary"] andWithPhoneNumber: [jsonData objectForKey: @"phoneNumber"] andWithEmail: [jsonData objectForKey: @"email"]];
}
+(NSDictionary*)JSONFromJob: (JFTJob*)job
{
    return @{
        @"companyName":job.CompanyName,
        @"branchName":job.BranchName,
        @"image":[UIImagePNGRepresentation(job.Image) base64EncodedStringWithOptions: 0],
        @"location":[JFTUtilities JSONFromLocation: job.Location],
        @"title":job.Title,
        @"type":job.Type,
        @"summary":job.Summary,
        @"phoneNumber":job.PhoneNumber,
        @"email":job.Email
    };
}
-(id)copy
{
    JFTJob* jobCopy = [[JFTJob alloc] initWithCompanyName: self.CompanyName andWithBranchName: self.BranchName andWithDescription: self.Description andWithImage: nil andWithLocation: self.Location andwithTitle: self.Title andWithType: self.Type andWithID: self.ID andWithSummary: self.Summary andWithPhoneNumber: self.PhoneNumber andWithEmail: self.Email];
    jobCopy.Image = self.Image;
    return jobCopy;
}
@end
