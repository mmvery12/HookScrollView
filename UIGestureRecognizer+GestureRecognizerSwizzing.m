//
//  UIGestureRecognizer+GestureRecognizerSwizzing.m
//  Demo
//
//  Created by JD on 17/2/20.
//  Copyright © 2017年 IMPTest. All rights reserved.
//

#import "UIGestureRecognizer+GestureRecognizerSwizzing.h"
#import <objc/runtime.h>
#import <JMAiOSClient/JMAiOSClient.h>
#import "UserManager.h"


@implementation UIGestureRecognizer (GestureRecognizerSwizzing)
@dynamic storePointArray;
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            SEL sel = NSSelectorFromString(@"initWithTarget:action:");
            SEL sel2 = NSSelectorFromString(@"minitWithTarget:action:");
            
            Method method = class_getInstanceMethod([self class], sel);
            Method method2 = class_getInstanceMethod([self class], sel2);
            method_exchangeImplementations(method, method2);
        }
        
        {
            SEL sel = NSSelectorFromString(@"removeTarget:action:");
            SEL sel2 = NSSelectorFromString(@"mremoveTarget:action:");
            
            Method method = class_getInstanceMethod([self class], sel);
            Method method2 = class_getInstanceMethod([self class], sel2);
            method_exchangeImplementations(method, method2);
        }
    });
}

- (instancetype)minitWithTarget:(nullable id)target action:(nullable SEL)action
{
    objc_setAssociatedObject(self, "mGestureRecognizerTarget", target, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, "mGestureRecognizerAction", NSStringFromSelector(action), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [self minitWithTarget:self action:@selector(mGestureRecognizerReceiver:)];
}


- (void)mremoveTarget:(nullable id)target action:(nullable SEL)action;
{
    id mtarget = objc_getAssociatedObject(self, "mGestureRecognizerTarget");
    NSString *mselstr = objc_getAssociatedObject(self, "mGestureRecognizerAction");
    if (target==mtarget && [mselstr isEqualToString:NSStringFromSelector(action)]) {
        [self mremoveTarget:self action:@selector(mGestureRecognizerReceiver:)];
    }else
        [self mremoveTarget:target action:action];
}


-(NSMutableArray *)storePointArray
{
    NSMutableArray *temp = objc_getAssociatedObject(self, "self.storePointArray");
    if (temp!=nil && [temp isKindOfClass:[NSArray class]]) {
        return temp;
    }else
    {
        temp = [NSMutableArray new];
        [self setStorePointArray:temp];
        return temp;
    }
}

-(void)setStorePointArray:(NSMutableArray *)storePointArray
{
    objc_setAssociatedObject(self, "self.storePointArray", storePointArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)mGestureRecognizerReceiver:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *mview = self.view;
    UIView *mtestView = self.view;
    NSString *viewControllerStr = nil;
    UIViewController *viewController = nil;
    for (; ; ) {
        id responser = mtestView.nextResponder;
        if ([responser isKindOfClass:[UIViewController class]]) {
            //viewController
            viewController = responser;
            viewControllerStr = [[responser class] description];
        }
        if (responser==nil || [responser isKindOfClass:[UIWindow class]] || [responser isKindOfClass:[UIApplication class]]) {
            break;
        }
        mtestView = responser;
    }
    
    
    
    id target = objc_getAssociatedObject(self, "mGestureRecognizerTarget");
    NSString *selstr = objc_getAssociatedObject(self, "mGestureRecognizerAction");
    SEL sel = NSSelectorFromString(selstr);
    NSMethodSignature  *signature = [[target class] instanceMethodSignatureForSelector:sel];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        NSUInteger argumentCount = signature.numberOfArguments;
        [invocation setArgument:&target atIndex:0];
        [invocation setArgument:&sel atIndex:1];
        for (int i=2; i<argumentCount; i++) {
            const char *type = [signature getArgumentTypeAtIndex:i];
            if ([[NSString stringWithUTF8String:type] isEqualToString:@"@"]) {
                [invocation setArgument:&gestureRecognizer atIndex:i];
            }else
            {
                int i=0;
                [invocation setArgument:&i atIndex:i];
            }
        }
        [invocation invoke];
    }
}
@end
