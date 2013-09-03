//
//  LeapVector+Tag.m
//  Slate
//
//  Created by Ömer Yildiz  on 09/03/13.
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

#import "LeapVector+Tag.h"
#import <objc/runtime.h>

@implementation LeapVector (Tag)

static char TAG_PROPERTY_KEY;

-(void)setTag:(NSString *)tag {
    objc_setAssociatedObject(self, &TAG_PROPERTY_KEY, tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)tag {
    return (NSString *) objc_getAssociatedObject(self, &TAG_PROPERTY_KEY);
}

+ (id)vectorWithTag:(NSString *)tag x:(float)x y:(float)y z:(float)z {
    LeapVector *result = [[LeapVector alloc] initWithX:x y:y z:z];
    result.tag = tag;
    return result;
}

@end