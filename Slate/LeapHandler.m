//
//  LeapHandler.m
//  Slate
//
//  Created by Ömer Yildiz  on 8/28/13.
//  Copyright 2013 Ömer Yildiz. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see http://www.gnu.org/licenses

#import "LeapHandler.h"
#import "SlateLogger.h"
#import "AccessibilityWrapper.h"
#import "Performance.h"


@implementation LeapHandler {
    LeapController *controller;
    NSMutableArray *history;
    NSMutableDictionary *currentPerformances;
}

- (id)init {
    self = [super init];
    if (self) {
        history = [NSMutableArray arrayWithCapacity:10];
        currentPerformances = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void)setup {
    controller = [[LeapController alloc] initWithDelegate:self];
}

- (void)onInit:(LeapController *)lc {
    SlateLogger(@"Leap.onInit");
}

- (void)onConnect:(LeapController *)lc {
    SlateLogger(@"Leap.onConnect");

    [lc enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    [lc enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
}

- (void)onDisconnect:(LeapController *)lc {
    SlateLogger(@"Leap.onDisconnect");
}

- (void)onExit:(LeapController *)lc {
    SlateLogger(@"Leap.onExit");
}

- (void)onFrame:(LeapController *)lc {
    LeapFrame *frame = [lc frame:0];
    NSArray *gestures = [frame gestures:nil];

    for (int g = 0; g < [gestures count]; g++) {
        LeapGesture *gesture = [gestures objectAtIndex:g];
        NSNumber *id = [NSNumber numberWithInt:gesture.id];

        switch (gesture.type) {
            case LEAP_GESTURE_TYPE_SCREEN_TAP: {
//                LeapScreenTapGesture *tap = (LeapScreenTapGesture *)gesture;
//                [AccessibilityWrapper windowUnderPoint:NSMakePoint(<#(CGFloat)x#>, <#(CGFloat)y#>)]

//                NSLog(@"Screen Tap id: %d, %@, position: %@, direction: %@",
//                        tap.id, [LeapHandler stringForState:tap.state],
//                        tap.position, tap.direction);
                break;
            }

            case LEAP_GESTURE_TYPE_SWIPE: {
                LeapSwipeGesture *swipe = (LeapSwipeGesture *)gesture;
//                SlateLogger(@"Swipe id: %d, %@, position: %@, direction: %@, speed: %f",
//                        swipe.id, [LeapHandler stringForState:swipe.state],
//                        swipe.position, swipe.direction, swipe.speed);

                switch (swipe.state) {
                    case LEAP_GESTURE_STATE_START: {
                        Performance *performance = [[Performance alloc] initWithSwipeGesture:swipe];

                        [history addObject:performance];
                        [currentPerformances setObject:performance forKey:id];

                        break;
                    }

                    case LEAP_GESTURE_STATE_UPDATE:
                    case LEAP_GESTURE_STATE_STOP: {
                        Performance *performance = [currentPerformances objectForKey:id];
                        if (!performance) SlateLogger(@"previous is nil");
                        [performance update:swipe];
                        break;
                    }

                    case LEAP_GESTURE_STATE_INVALID: {
                        SlateLogger(@"Invalid swipe id=%d", swipe.id);
                        break;
                    }
                }

                break;
            }

            default: {
                break;
            }
        }
    }
}

+ (NSString *)stringForState:(LeapGestureState)state
{
    switch (state) {
        case LEAP_GESTURE_STATE_INVALID:
            return @"STATE_INVALID";
        case LEAP_GESTURE_STATE_START:
            return @"STATE_START";
        case LEAP_GESTURE_STATE_UPDATE:
            return @"STATE_UPDATED";
        case LEAP_GESTURE_STATE_STOP:
            return @"STATE_STOP";
        default:
            return @"STATE_INVALID";
    }
}

@end