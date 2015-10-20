//
//  ExternalScreenManager.m
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



#import "ExternalScreenManager.h"



@implementation ExternalScreenManager



@synthesize externalScreen;



#pragma mark -
#pragma mark Singleton Methods



static ExternalScreenManager* sharedInstance;



+ (ExternalScreenManager*)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[ExternalScreenManager alloc] init];
    }
    
    return sharedInstance;
}



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)init
{
    self = [super init];
    
    if (self)
    {
        _delegates = [NSMutableArray array];
        
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


- (void)addDelegate:(id<ExternalScreenManagerDelegate>)delegate;
{
    [self.delegates addObject:delegate];
    
    
    UIScreen* lExternalScreen = [self externalScreen];
    if (lExternalScreen)
    {
        [delegate screenDidConnect:lExternalScreen];
    }
}


- (void)removeDelegate:(id<ExternalScreenManagerDelegate>)delegate;
{
    [self.delegates removeObject:delegate];
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
#pragma mark Public Methods



- (UIScreen*)externalScreen
{
    if ([[UIScreen screens] count] > 1)
    {
        for (UIScreen* aScreen in [UIScreen screens])
        {
            if (aScreen != [UIScreen mainScreen])
            {
                return aScreen;
            }
        }
    }
    
    return nil;
}



#pragma mark -
#pragma mark Screen Support Methods



- (void)handleScreenDidConnectNotification:(NSNotification*)notification
{
    if ([_delegates count] > 0 && [notification object] && [[notification object] isKindOfClass:[UIScreen class]])
    {
        externalScreen = (UIScreen*)[notification object];
        
        for (id<ExternalScreenManagerDelegate> aDelegate in _delegates)
        {
            [aDelegate screenDidConnect:externalScreen];
        }
    }
}


- (void)handleScreenDidDisconnectNotification:(NSNotification*)notification
{
    if ([notification object] && [[notification object] isKindOfClass:[UIScreen class]])
    {
        UIScreen* lScreen = (UIScreen*)[notification object];
        externalScreen = nil;
        
        for (id<ExternalScreenManagerDelegate> aDelegate in _delegates)
        {
            [aDelegate screenDidDisconnect:lScreen];
        }
    }
}


@end
