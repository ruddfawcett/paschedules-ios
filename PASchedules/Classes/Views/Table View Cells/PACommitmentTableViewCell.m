//
//  PACommitmentTableViewCell.m
//  PASchedules
//
//  Created by Rudd Fawcett on 11/20/14.
//  Copyright (c) 2014 Rudd Fawcett. All rights reserved.
//

#import "PACommitmentTableViewCell.h"

@implementation PACommitmentTableViewCell

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


- (void)setCommitment:(PACommitment *)commitment {
    self.textLabel.text = commitment.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ \n%@", commitment.name, (![commitment.teacher.name isKindOfClass:[NSNull class]]) ? commitment.teacher.name : @"Not available"];
}

@end
