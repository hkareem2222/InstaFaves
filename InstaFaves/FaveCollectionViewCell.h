//
//  FaveCollectionViewCell.h
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaveCollectionViewCell;

@protocol FaveCollectionViewCellDelegate <NSObject>

-(void)faveCollectionViewCell:(FaveCollectionViewCell *)cell didTapDeleteButton:(UIButton *)button;
-(void)faveCollectionViewCell:(FaveCollectionViewCell *)cell didTapShareButton:(UIButton *)button;

@end

@interface FaveCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) id <FaveCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@end
