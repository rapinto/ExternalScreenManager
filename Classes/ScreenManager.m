//
//  ScreenManager.m
//
//
//  Created by Raphaël Pinto on 31/08/2015.
//
// The MIT License (MIT)
// Copyright (c) 2015 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "ScreenManager.h"
#import "ScreenManagerDelegate.h"



@implementation ScreenManager



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)initWithDelegate:(id<ScreenManagerDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
        [self checkForExistingScreens];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleScreenDidConnectNotification:)
                                                     name:UIScreenDidConnectNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleScreenDidDisconnectNotification:)
                                                     name:UIScreenDidDisconnectNotification
                                                   object:nil];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidConnectNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidDisconnectNotification
                                                  object:nil];
}



#pragma mark -
#pragma mark Screen Support Methods



- (void)checkForExistingScreens
{
    
    if ([[UIScreen screens] count] > 1)
    {
        for (UIScreen* aScreen in [UIScreen screens])
        {
            if (aScreen != [UIScreen mainScreen])
            {
                [_delegate screenDidConnect:aScreen];
            }
        }
    }
}


- (void)handleScreenDidConnectNotification:(NSNotification*)notification
{
    if (_delegate && [notification object] && [[notification object] isKindOfClass:[UIScreen class]])
    {
        UIScreen* lScreen = (UIScreen*)[notification object];
        
        [_delegate screenDidConnect:lScreen];
    }
}


- (void)handleScreenDidDisconnectNotification:(NSNotification*)notification
{
    if ([notification object] && [[notification object] isKindOfClass:[UIScreen class]])
    {
        UIScreen* lScreen = (UIScreen*)[notification object];
        
        [_delegate screenDidDisconnect:lScreen];
    }
}


@end
