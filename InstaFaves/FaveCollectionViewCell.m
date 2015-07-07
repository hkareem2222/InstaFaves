//
//  FaveCollectionViewCell.m
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import "FaveCollectionViewCell.h"

@implementation FaveCollectionViewCell

- (IBAction)onDeleteButtonTapped:(UIButton *)sender {
    NSLog(@"called inside");
    [self.delegate faveCollectionViewCell:self didTapDeleteButton:sender];
}
- (IBAction)onShareButtonTapped:(UIButton *)sender {
    [self.delegate faveCollectionViewCell:self didTapShareButton:sender];
}

@end
