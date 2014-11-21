//
//  PACourseTableViewCell.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACourseTableViewCell.h"

@implementation PACourseTableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[self.class alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return self;
}

- (void)setCourse:(PACourse *)course {
    self.textLabel.text = course.sectionName;
    
    if (course.teacherName != nil) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@ \n%@", course.teacherName, course.room];
    }
    else {
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@", course.room];
    }
}

@end
