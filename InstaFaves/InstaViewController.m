//
//  InstaViewController.m
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import "InstaViewController.h"
#import "InstaCollectionViewCell.h"

@interface InstaViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UISearchBar *tagSearchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation InstaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setSelectedItem:self.tabBar.items[1]];
    self.tabBar.delegate = self;

    //sets searchbar to clear but then background turns black? from collectionview
//    self.tagSearchBar.barTintColor = [UIColor clearColor];
//    self.userSearchBar.barTintColor = [UIColor clearColor];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

-(InstaCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InstaCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageID" forIndexPath:indexPath];

    return cell;
}
- (IBAction)onSearchButtonTapped:(UIButton *)button {

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self performSegueWithIdentifier:@"unwindToMyFaves" sender:item];
    }
}
@end
