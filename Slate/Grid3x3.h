//
//  Grid3x3.h
//  Slate
//
//  Created by Ömer Yildiz  on 8/30/13.
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


#import <Foundation/Foundation.h>

/**
 * The possible swipe gesture directions
 */
typedef enum GestureDirection {
    GESTURE_DIRECTION_TOP_LEFT,
    GESTURE_DIRECTION_TOP,
    GESTURE_DIRECTION_TOP_RIGHT,
    GESTURE_DIRECTION_RIGHT,
    GESTURE_DIRECTION_BOTTOM_RIGHT,
    GESTURE_DIRECITON_BOTTOM,
    GESTURE_DIRECTION_BOTTOM_LEFT,
    GESTURE_DIRECTION_LEFT
} GestureDirection;

@class LeapVector;

@interface Grid3x3 : NSObject {
}

- (NSString *)gridCoordinatesOf:(LeapVector *)vector;

@end