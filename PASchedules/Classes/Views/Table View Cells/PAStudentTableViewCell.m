//
//  PAStudentTableViewCell.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PAStudentTableViewCell.h"

@implementation PAStudentTableViewCell

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

- (void)setStudent:(PAStudent *)student {
    self.textLabel.text = student.name;
    
    if (student.nickname != nil) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"Goes by %@\nClass of %lu", student.nickname, (unsigned long)student.graduation];
    }
    else {
        self.detailTextLabel.text = [NSString stringWithFormat:@"Class of %lu", (unsigned long)student.graduation];
    }
}

@end
