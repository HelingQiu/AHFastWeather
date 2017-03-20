//
//  AFLoginViewController.h
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFBaseViewController.h"
#import "AFFirstViewController.h"
#import "AFSecondViewController.h"
#import "AFThirdViewController.h"
#import "AFForthViewController.h"
#import "AFFifthViewController.h"
#import "AFSixthViewController.h"
#import <RDVTabBarController.h>
#import <RDVTabBarItem.h>
#import "UINavigationController+TRVSNavigationControllerTransition.h"

@interface AFLoginViewController : AFBaseViewController

@property(nonatomic) BOOL isReLogin;

typedef void (^LoginSuccessRefreshBlock)();

@property (nonatomic, strong) LoginSuccessRefreshBlock block;

@end
