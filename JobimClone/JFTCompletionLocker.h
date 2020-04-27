//
//  JFTCompletionLocker.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 06/04/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JFTCompletionLocker <NSObject>
-(BOOL)pageFillingCompleted;
@end

NS_ASSUME_NONNULL_END
