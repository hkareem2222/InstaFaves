//
//  ViewController.m
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import "MyFaveViewController.h"
#import "FaveCollectionViewCell.h"

@interface MyFaveViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@end

@implementation MyFaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setSelectedItem:self.tabBar.items[0]];
    self.tabBar.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tabBar setSelectedItem:self.tabBar.items[0]];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

-(FaveCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FaveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageID" forIndexPath:indexPath];
    return cell;
}

- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender {
}
- (IBAction)onSeeMapButtonTapped:(UIButton *)sender {
}

-(IBAction)unwindToMyFaves:(UIStoryboardSegue *)segue {
    //from MapViewController
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 1) {
        [self performSegueWithIdentifier:@"InstaPhotosSegue" sender:item];
    }
}

@end
