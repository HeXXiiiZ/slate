//
//  Performance.m
//  Slate
//
//  Created by Ömer Yildiz  on 8/29/13.
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


#import "Performance.h"
#import "LeapObjectiveC.h"
#import "SlateLogger.h"
#import "LeapVector+Tag.h"
#import "LeapConstants.h"


@implementation Performance {
    NSMutableArray *directionHistory;
}

@synthesize gesture = _gesture;
@synthesize direction = _direction;
@synthesize id = _id;

static LeapVector *VECTOR_BOTTOM_LEFT;
static LeapVector *VECTOR_BOTTOM;
static LeapVector *VECTOR_BOTTOM_RIGHT;
static LeapVector *VECTOR_RIGHT;
static LeapVector *VECTOR_TOP_RIGHT;
static LeapVector *VECTOR_TOP;
static LeapVector *VECTOR_TOP_LEFT;
static LeapVector *VECTOR_LEFT;
static NSArray *GESTURE_DIRECTIONS;

+ (void)initialize {
    VECTOR_BOTTOM_LEFT  = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_BOTTOM_LEFT  x:-1 y:-1 z:0];
    VECTOR_BOTTOM       = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_BOTTOM       x:+0 y:-1 z:0];
    VECTOR_BOTTOM_RIGHT = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_BOTTOM_RIGHT x:+1 y:-1 z:0];
    VECTOR_RIGHT        = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_RIGHT        x:+1 y:+0 z:0];
    VECTOR_TOP_RIGHT    = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_TOP_RIGHT    x:+1 y:+1 z:0];
    VECTOR_TOP          = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_TOP          x:+0 y:+1 z:0];
    VECTOR_TOP_LEFT     = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_TOP_LEFT     x:-1 y:+1 z:0];
    VECTOR_LEFT         = [LeapVector vectorWithTag:LEAP_GESTURE_DIRECTION_LEFT         x:-1 y:+0 z:0];
    
    GESTURE_DIRECTIONS  = [NSArray arrayWithObjects:VECTOR_TOP_LEFT,    VECTOR_TOP,    VECTOR_TOP_RIGHT, 
                                                    VECTOR_LEFT,                       VECTOR_RIGHT,
                                                    VECTOR_BOTTOM_LEFT, VECTOR_BOTTOM, VECTOR_BOTTOM_RIGHT, 
                                                    nil];
}

- (id)initWithSwipeGesture:(LeapSwipeGesture *)g {
    self = [super init];
    if (self) {
        _id = g.id;
        _averageDirection = g.direction;
        directionHistory = [[NSMutableArray alloc] initWithCapacity:50];
        [self update:g];

        SlateLogger(@"Performance(%d, swipe)", g.id);
    }
    return self;
}

- (id)initWithGestureType:(LeapGestureType)type direction:(NSString *)direction {
    self = [super init];
    if (self) {
        _id = -1;
        _averageDirection = nil;
        _type = type;
        _direction = direction;
    }
    return self;
}


- (void)update:(LeapSwipeGesture *)g {
    if (g.id != _id) SlateLogger(@"Invalid update object %d != %d", g.id, _id);

    _gesture = g;
    _capturedFrames++;

    [directionHistory addObject:g.direction];

    if (g.state == LEAP_GESTURE_STATE_STOP) {
        LeapVector *sum = [[LeapVector alloc] init];
        for (int i = 0; i < [directionHistory count]; i++) {
            sum = [sum plus:[directionHistory objectAtIndex:i]];
        }

        _averageDirection = [sum divide:[directionHistory count]];
        [directionHistory removeAllObjects];
        _direction = [Performance directionOf:_averageDirection];
        
        SlateLogger(@"  Performed(%d, swipe, %@):", _id, _direction);
    }
}

+ (NSString *)directionOf:(LeapVector *)dirVector {
    NSMutableArray *angles = [NSMutableArray arrayWithCapacity:[GESTURE_DIRECTIONS count]];

    for (LeapVector *vector in GESTURE_DIRECTIONS) {
        NSArray *pair = @[vector.tag, [NSNumber numberWithFloat:[vector angleTo:dirVector]]];
        [angles addObject:pair];
    }

    [angles sortUsingComparator:^(NSArray *obj1, NSArray *obj2) {
        return [[obj1 objectAtIndex:1] compare:[obj2 objectAtIndex:1]];
    }];

    NSArray *best = [angles objectAtIndex:0];
    NSString *direction = [best objectAtIndex:0];
//    NSNumber *angle = [best objectAtIndex:1];
//    SlateLogger(@"direction=%@ angle=%f", direction, angle.floatValue * 180 / pi);

    return direction;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    Performance *o = (Performance *) other;
    if (_id == o.id) 
        return YES;
    
    if (_type != o.type)
        return NO;
    
    if ([_direction isEqual:o.direction])
        return YES;
    
    return NO;
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    NSUInteger prime = 31;
//    NSUInteger yesPrime = 1231;
//    NSUInteger noPrime = 1237;

    result = prime * result + [self.direction hash];
    result = prime * result + self.type;
    
    return result;
}
}


@end