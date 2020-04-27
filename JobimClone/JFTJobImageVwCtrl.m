//
//  JFTJobImageVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobImageVwCtrl.h"
#import "JFTJobInfoVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTJobImageVwCtrl ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end
@implementation JFTJobImageVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (LocalJob.Image != nil)
        self.jobImg.image = LocalJob.Image;
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
- (IBAction)onOpenImagePickerTouch:(id)sender
{
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];
}
#pragma mark - ImagePicker Controls
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    LocalJob.Image = image;
    self.jobImg.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
