//
//  Label.m
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/21/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import "Label.h"

@implementation Label

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
