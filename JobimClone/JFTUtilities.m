//
//  Utilities.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTPersonalInfoVwCtrl.h"
#import "JFTJobMKAnnotation.h"
#import "JFTImageCacheStore.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
#import "JFTJob.h"
CLLocation* LocalLocation;
JFTUser* LocalUser;
JFTJob* LocalJob;
@implementation JFTUtilities
#pragma mark - Firebase Utilities
+(FIRDatabaseReference*)globalDatabaseReference
{
    static FIRDatabaseReference* ref;
    if (!ref)
    {
        ref = [[FIRDatabase database] reference];
    }
    return ref;
}
+(void)passToDatabaseUpdateIfNotRegistrationPage: (JFTUserProperty)property withValue: (id)value from: (UIViewController*)viewController
{
    JFTPersonalInfoVwCtrl* personalInfoVwCtrl = (JFTPersonalInfoVwCtrl*)viewController.parentViewController;
    if (!(LocalUser.ID == nil))
    {
        if (personalInfoVwCtrl.isRegistrationPage == NO)
        {
            [JFTUser updateUserInformation: property withValue: value];
        }
    }
}
#pragma mark - Location Utilities
+(CLLocation*)locationFromJSON: (NSDictionary*)jsonLocation
{
    return [[CLLocation alloc] initWithLatitude: [[jsonLocation objectForKey: @"lat"] doubleValue] longitude: [[jsonLocation objectForKey: @"long"] doubleValue]];
}
+(NSDictionary*)JSONFromLocation: (CLLocation*)location
{
    return @{
        @"lat":[NSNumber numberWithDouble: location.coordinate.latitude],
        @"long":[NSNumber numberWithDouble: location.coordinate.longitude]
    };
}
#pragma mark - Adress From Location and It's Support Functions
+(void)addressFromLocation: (CLLocation*)location andSender: (id)sender
{
    CLGeocoder *geocoder = [CLGeocoder new];
    __block NSString *address;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             address = [NSString stringWithFormat:@"%@ %@,%@ %@", ([placemark subThoroughfare] == nil ? @"" : [placemark subThoroughfare]),([placemark thoroughfare] == nil ? @"" : [placemark thoroughfare]),[placemark locality], [placemark country]];
             NSLog(@"%@", address);
         }
        else
            address = @"404 Not Found!";
        [JFTUtilities setAdress: address forRequestingObject: sender];
     }];
}
+(void)addressFromLocation: (CLLocation*)location andSender: (id)sender onCompletion: (nullable void (^)(void))completionBlock
{
    CLGeocoder *geocoder = [CLGeocoder new];
    __block NSString *address;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             address = [NSString stringWithFormat:@"%@ %@,%@ %@", ([[placemark subThoroughfare] isEqualToString: @"(null)"]?[placemark subThoroughfare]:@""),[placemark thoroughfare],[placemark locality], [placemark country]];
             NSLog(@"%@", address);
         }
        else
            address = @"404 Not Found!";
        [JFTUtilities setAdress: address forRequestingObject: sender];
        completionBlock();
     }];
}
+(void)setAdress: (NSString*)address forRequestingObject: (id)sender
{
    if ([sender isKindOfClass: [UITextField class]])
        [JFTUtilities setAdress: address forTextFieldCaller: (UITextField*)sender];
    else if ([sender isKindOfClass: [UISearchBar class]])
        [JFTUtilities setAdress: address forSearchBarCaller: (UISearchBar*)sender];
    else if ([sender isKindOfClass: [UILabel class]])
        [JFTUtilities setAdress: address forLabelCaller: (UILabel*)sender];
    else if ([sender isKindOfClass: [NSString class]])
        [JFTUtilities setAdress: address forStringCaller: &sender];
    else if ([sender isKindOfClass: JFTJob.class])
        [JFTUtilities setAdress: address forJobCaller: (JFTJob *)sender];
    else
        @throw [NSException exceptionWithName: @"Unsupported Caller" reason: @"Please Contact Source Code Administrator or override the method yourself." userInfo: nil];
}
+(void)setAdress: (NSString*)address forTextFieldCaller: (UITextField*)textField
{
    textField.text = [address copy];
}
+(void)setAdress: (NSString*)address forSearchBarCaller: (UISearchBar*)searchBar
{
    searchBar.text = [address copy];
}
+(void)setAdress: (NSString*)address forLabelCaller: (UILabel*)label
{
    label.text = [address copy];
}
+(void)setAdress: (NSString*)address forStringCaller: (NSString**)string
{
    *string = address;
}
+(void)setAdress: (NSString*)address forJobCaller: (JFTJob*)job
{
    job.LiteralLocation = address;
}
#pragma mark - Location From Adress and It's Support Functions
+(void)locationFromAddress: (NSString*)address andSender: (CLLocation*)sender
{
    CLGeocoder *geocoder = [CLGeocoder new];
    __block CLLocation* locationFromAdress;
    [geocoder geocodeAddressString: address completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            [JFTUtilities setLocation: [CLLocation new] toLocationCaller: sender];
            return;
        }
        if (placemarks && [placemarks count] > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            locationFromAdress = placemark.location;
            [JFTUtilities setLocation: locationFromAdress toLocationCaller: sender];
        }
    }];
}
+(void)locationFromAddress: (NSString*)address andSender: (CLLocation*)sender onCompletion: (nullable void (^)(void))completionBlock
{
    CLGeocoder *geocoder = [CLGeocoder new];
    __block CLLocation* locationFromAdress;
    [geocoder geocodeAddressString: address completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
            [JFTUtilities setLocation: [CLLocation new] toLocationCaller: sender];
            return;
        }
        if (placemarks && [placemarks count] > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            locationFromAdress = placemark.location;
            [JFTUtilities setLocation: locationFromAdress toLocationCaller: sender];
            completionBlock();
        }
    }];
}
+(void)setLocation: (CLLocation*)location toLocationCaller: (CLLocation*)caller
{
    caller = [location copy];
}
#pragma mark - Location Related ViewController Utilities
+(void)centerViewForMKMapView:(MKMapView *)mapView forLocation:(CLLocation *)location withSquareSizeOf:(float)edgeLength
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, edgeLength, edgeLength);
    [mapView setRegion: viewRegion animated: YES];
}
+(void)addJobPinToMKMapView:(MKMapView *)mapView theJob:(JFTJob *)job
{
    JFTJobMKAnnotation* jobAnnotation = [[JFTJobMKAnnotation alloc] initWithJobTitle: job.Title jobType: job.Type coordinate: job.Location.coordinate andJobID: job.ID];
    [mapView addAnnotation: jobAnnotation];
}
#pragma mark - View Controller Utilities
+(void)showErrorInAlert: (NSError*)error onView: (UIViewController*)caller
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Error!" message: [error localizedDescription] preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {}];
    [alert addAction: alertAction];
    [caller presentViewController:alert animated:YES completion:nil];
    return;
}
+(void)shoeAlertForText: (NSString*)text onView: (UIViewController*)caller
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"" message: text preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {}];
    [alert addAction: alertAction];
    [caller presentViewController:alert animated:YES completion:nil];
    return;
}
+(void)setViewControllerNavigationBarFor: (UIViewController*)viewController with: (JFTNavBarLeftButtonTypes)leftButtonType and: (JFTNavBarRightButtonTypes)rightButtonType
{
    switch (leftButtonType)
    {
        case JFTNavBarLeftButtonTypeX:
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"x" style: UIBarButtonItemStylePlain target: viewController action: @selector(onCloseButtonTouch:)];
            break;
        case JFTNavBarLeftButtonTypeOpenSideBar:
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"OpenMenuIcon.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] style: UIBarButtonItemStylePlain target: viewController action: @selector(onOpenSidebarButtonTouch:)];
            break;
        default:
            break;
    }
    switch (rightButtonType) {
        case JFTNavBarRightButtonTypeOpenMapView:
            if ([viewController isKindOfClass: [UITableViewController class]] == YES)
                viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"OpenMapViewIcon.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] style: UIBarButtonItemStylePlain target: viewController action: @selector(onToggleMapButtonTouch:)];
            else
                viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"OpenTableViewIcon.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] style: UIBarButtonItemStylePlain target: viewController action: @selector(onToggleMapButtonTouch:)];
            break;
        case JFTNavBarRightButtonTypeAdd:
            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"+" style: UIBarButtonItemStylePlain target: viewController action: @selector(onAddButtonTouch:)];
            break;
        default:
            break;
    }
    viewController.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
    if (rightButtonType != JFTNavBarRightButtonTypeNone)
        viewController.navigationItem.rightBarButtonItem.tintColor = UIColor.whiteColor;
}
#pragma mark - Image Utilities
+(UIImage*)convertImage: (UIImage*)image toSize: (CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
#pragma mark - Color Utilites
+(UIColor*)lightenColor: (UIColor*)color
{
    CGFloat r, g, b, a;
    if ([color getRed: &r green: &g blue: &b alpha: &a])
        return [UIColor colorWithRed:MAX(r + 0.2, 0.0) green:MAX(g + 0.2, 0.0) blue:MAX(b + 0.2, 0.0) alpha:a];
    return color;
}
+(UIColor*)darkenColor: (UIColor*)color
{
    CGFloat r, g, b, a;
    if ([color getRed: &r green: &g blue: &b alpha: &a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0) green:MAX(g - 0.2, 0.0) blue:MAX(b - 0.2, 0.0) alpha:a];
    return color;
}
#pragma mark - String Utilities
+(BOOL)verifyInputForPhoneNumber: (NSString*)input
{
    NSString* processedInput = [JFTUtilities cleanPhoneNumber: input];
    if (processedInput.length > 10)
        return NO;
    else if (processedInput.length == 10)
        return YES;
    else
        return NO;
}
+(NSString*)appendAreaCodeToPhoneNumber: (NSString*)phoneNumber
{
    NSString* cleanedPhoneNumber = [JFTUtilities cleanPhoneNumber: phoneNumber];
    return [cleanedPhoneNumber stringByReplacingCharactersInRange: NSMakeRange( 0, 1) withString: [NSString stringWithFormat:@"+%@", [JFTUtilities areaCodeForCurrentLocation]]];
}
+(NSString*)cleanPhoneNumber: (NSString*)phoneNumber
{
    NSMutableString* processedInput = [NSMutableString stringWithString: phoneNumber];
    [processedInput replaceOccurrencesOfString: @"-" withString: @"" options: NSCaseInsensitiveSearch range: NSMakeRange(0, processedInput.length)];
    return [NSString stringWithString: processedInput];
}
+(NSString*)areaCodeForCurrentLocation
{
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSString* countryCode = [currentLocale objectForKey: NSLocaleCountryCode];
    NSDictionary* countryCodeToAreaCode = @{
        @"AF": @"93",
        @"AL": @"355",
        @"DZ": @"213",
        @"AS": @"1",
        @"AD": @"376",
        @"AO": @"244",
        @"AI": @"1",
        @"AQ": @"672",
        @"AG": @"1",
        @"AR": @"54",
        @"AM": @"374",
        @"AW": @"297",
        @"AU": @"61",
        @"AT": @"43",
        @"AZ": @"994",
        @"BS": @"1",
        @"BH": @"973",
        @"BD": @"880",
        @"BB": @"1",
        @"BY": @"375",
        @"BE": @"32",
        @"BZ": @"501",
        @"BJ": @"229",
        @"BM": @"1",
        @"BT": @"975",
        @"BA": @"387",
        @"BW": @"267",
        @"BR": @"55",
        @"IO": @"246",
        @"BG": @"359",
        @"BF": @"226",
        @"BI": @"257",
        @"KH": @"855",
        @"CM": @"237",
        @"CA": @"1",
        @"CV": @"238",
        @"KY": @"345",
        @"CF": @"236",
        @"TD": @"235",
        @"CL": @"56",
        @"CN": @"86",
        @"CX": @"61",
        @"CO": @"57",
        @"KM": @"269",
        @"CG": @"242",
        @"CK": @"682",
        @"CR": @"506",
        @"HR": @"385",
        @"CU": @"53",
        @"CY": @"537",
        @"CZ": @"420",
        @"DK": @"45",
        @"DJ": @"253",
        @"DM": @"1",
        @"DO": @"1",
        @"EC": @"593",
        @"EG": @"20",
        @"SV": @"503",
        @"GQ": @"240",
        @"ER": @"291",
        @"EE": @"372",
        @"ET": @"251",
        @"FO": @"298",
        @"FJ": @"679",
        @"FI": @"358",
        @"FR": @"33",
        @"GF": @"594",
        @"PF": @"689",
        @"GA": @"241",
        @"GM": @"220",
        @"GE": @"995",
        @"DE": @"49",
        @"GH": @"233",
        @"GI": @"350",
        @"GR": @"30",
        @"GL": @"299",
        @"GD": @"1",
        @"GP": @"590",
        @"GU": @"1",
        @"GT": @"502",
        @"GN": @"224",
        @"GW": @"245",
        @"GY": @"595",
        @"HT": @"509",
        @"HN": @"504",
        @"HU": @"36",
        @"IS": @"354",
        @"IN": @"91",
        @"ID": @"62",
        @"IQ": @"964",
        @"IE": @"353",
        @"IL": @"972",
        @"IT": @"39",
        @"JM": @"1",
        @"JP": @"81",
        @"JO": @"962",
        @"KZ": @"77",
        @"KE": @"254",
        @"KI": @"686",
        @"KW": @"965",
        @"KG": @"996",
        @"LV": @"371",
        @"LB": @"961",
        @"LS": @"266",
        @"LR": @"231",
        @"LI": @"423",
        @"LT": @"370",
        @"LU": @"352",
        @"MG": @"261",
        @"MW": @"265",
        @"MY": @"60",
        @"MV": @"960",
        @"ML": @"223",
        @"MT": @"356",
        @"MH": @"692",
        @"MQ": @"596",
        @"MR": @"222",
        @"MU": @"230",
        @"YT": @"262",
        @"MX": @"52",
        @"MC": @"377",
        @"MN": @"976",
        @"ME": @"382",
        @"MS": @"1",
        @"MA": @"212",
        @"MM": @"95",
        @"NA": @"264",
        @"NR": @"674",
        @"NP": @"977",
        @"NL": @"31",
        @"AN": @"599",
        @"NC": @"687",
        @"NZ": @"64",
        @"NI": @"505",
        @"NE": @"227",
        @"NG": @"234",
        @"NU": @"683",
        @"NF": @"672",
        @"MP": @"1",
        @"NO": @"47",
        @"OM": @"968",
        @"PK": @"92",
        @"PW": @"680",
        @"PA": @"507",
        @"PG": @"675",
        @"PY": @"595",
        @"PE": @"51",
        @"PH": @"63",
        @"PL": @"48",
        @"PT": @"351",
        @"PR": @"1",
        @"QA": @"974",
        @"RO": @"40",
        @"RW": @"250",
        @"WS": @"685",
        @"SM": @"378",
        @"SA": @"966",
        @"SN": @"221",
        @"RS": @"381",
        @"SC": @"248",
        @"SL": @"232",
        @"SG": @"65",
        @"SK": @"421",
        @"SI": @"386",
        @"SB": @"677",
        @"ZA": @"27",
        @"GS": @"500",
        @"ES": @"34",
        @"LK": @"94",
        @"SD": @"249",
        @"SR": @"597",
        @"SZ": @"268",
        @"SE": @"46",
        @"CH": @"41",
        @"TJ": @"992",
        @"TH": @"66",
        @"TG": @"228",
        @"TK": @"690",
        @"TO": @"676",
        @"TT": @"1",
        @"TN": @"216",
        @"TR": @"90",
        @"TM": @"993",
        @"TC": @"1",
        @"TV": @"688",
        @"UG": @"256",
        @"UA": @"380",
        @"AE": @"971",
        @"GB": @"44",
        @"US": @"1",
        @"UY": @"598",
        @"UZ": @"998",
        @"VU": @"678",
        @"WF": @"681",
        @"YE": @"967",
        @"ZM": @"260",
        @"ZW": @"263",
        @"BO": @"591",
        @"BN": @"673",
        @"CC": @"61",
        @"CD": @"243",
        @"CI": @"225",
        @"FK": @"500",
        @"GG": @"44",
        @"VA": @"379",
        @"HK": @"852",
        @"IR": @"98",
        @"IM": @"44",
        @"JE": @"44",
        @"KP": @"850",
        @"KR": @"82",
        @"LA": @"856",
        @"LY": @"218",
        @"MO": @"853",
        @"MK": @"389",
        @"FM": @"691",
        @"MD": @"373",
        @"MZ": @"258",
        @"PS": @"970",
        @"PN": @"872",
        @"RE": @"262",
        @"RU": @"7",
        @"BL": @"590",
        @"SH": @"290",
        @"KN": @"1",
        @"LC": @"1",
        @"MF": @"590",
        @"PM": @"508",
        @"VC": @"1",
        @"ST": @"239",
        @"SO": @"252",
        @"SJ": @"47",
        @"SY": @"963",
        @"TW": @"886",
        @"TZ": @"255",
        @"TL": @"670",
        @"VE": @"58",
        @"VN": @"84",
        @"VG": @"284",
        @"VI": @"340",
        @"EH": @"121"
    };
    return countryCodeToAreaCode[countryCode];
}
@end
