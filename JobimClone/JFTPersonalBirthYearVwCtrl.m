//
//  JFTPersonalBirthYearVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTPersonalBirthYearVwCtrl.h"
#import "JFTPersonalInfoVwCtrl.h"
#import "JFTCompletionLocker.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
static NSMutableArray* years;
@interface JFTPersonalBirthYearVwCtrl ()
<UIPickerViewDelegate,UIPickerViewDataSource, JFTCompletionLocker>
@property (nonatomic) int currentYear;
@property (nonatomic) BOOL didSelect;
@end
@implementation JFTPersonalBirthYearVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCurrentYear];
    self.didSelect = NO;
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    if (!years)
    {
        years = [NSMutableArray new];
        @autoreleasepool
        {
            for (int i = 1900; i <= self.currentYear; i++)
                [years addObject: [NSString stringWithFormat: @"%d", i]];
        }
    }
    int indexOfUserYear = LocalUser.BirthYear - 1900;
    if (((JFTPersonalInfoVwCtrl*)self.parentViewController).isRegistrationPage == NO)
        [self.yearPicker selectRow: indexOfUserYear inComponent: 0 animated: YES];
}
#pragma mark - PickerView Controls
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return years.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.didSelect = YES;
    return years[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LocalUser.BirthYear = [years[row] intValue];
    [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyBirthYear withValue: [NSNumber numberWithInt: LocalUser.BirthYear] from: self];
}
#pragma mark - Completion Locker Controls
-(BOOL)pageFillingCompleted
{
    return self.didSelect;
}
#pragma mark - Helper Methods
-(void)setCurrentYear
{
    static NSDateFormatter* formatter = nil;
    if (!formatter)
    {
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy"];
    }
    self.currentYear  = [[formatter stringFromDate:[NSDate date]] intValue];
}
@end
