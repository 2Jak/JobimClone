//
//  JFTJobMKAnnotation.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 23/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobMKAnnotation.h"
@interface JFTJobMKAnnotation()
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@property (nonatomic, copy) NSString* jobTitle;
@property (nonatomic, copy) NSString* jobType;
@property (nonatomic, copy) NSString* jobID;
@end
@implementation JFTJobMKAnnotation
#pragma mark - Constructors
- (id)initWithJobTitle:(NSString*)title jobType:(NSString*)type coordinate:(CLLocationCoordinate2D)coordinate andJobID: (NSString*)jobID
{
    if ((self = [super init]))
    {
        self.jobTitle = title;
        self.jobType = type;
        self.theCoordinate = coordinate;
        self.jobID = jobID;
    }
    return self;
}
#pragma mark - Getters
-(NSString *)title
{
    return self.jobTitle;
}
-(NSString *)subtitle
{
    return self.jobType;
}
-(CLLocationCoordinate2D)coordinate
{
    return _theCoordinate;
}
-(NSString*)jobID
{
    return self.jobID;
}
-(MKMapItem*)mapItem
{
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate: self.coordinate];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark: placemark];
    mapItem.name = self.title;
    return mapItem;
}

@end
