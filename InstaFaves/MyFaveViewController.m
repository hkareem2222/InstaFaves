//
//  ViewController.m
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import "MyFaveViewController.h"
#import "FaveCollectionViewCell.h"
#import "InstaViewController.h"
#import "Picture.h"

@interface MyFaveViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property NSMutableArray *pictureURLStrings;
@property UIButton *deleteButtonOnCell;
@property UIButton *shareButtonOnCell;
@property BOOL isEditable;
@end

@implementation MyFaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setSelectedItem:self.tabBar.items[0]];
    self.tabBar.delegate = self;
    self.isEditable = NO;
    [self load];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tabBar setSelectedItem:self.tabBar.items[0]];
}

- (IBAction)onSeeMapButtonTapped:(UIButton *)sender {
}

#pragma mark - CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictureURLStrings.count;
}

-(FaveCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FaveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageID" forIndexPath:indexPath];

    //speed up scroll by doing what you did in other view controller
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictureURLStrings[indexPath.row]]]];
    cell.deleteButton.alpha = 0.0;
    cell.shareButton.alpha = 0.0;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    FaveCollectionViewCell *cell = (FaveCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    self.isEditable = !self.isEditable;
    if (self.isEditable) {
        //animating UIButton on cell for favorite
        self.deleteButtonOnCell = cell.deleteButton;
        self.shareButtonOnCell = cell.shareButton;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

        [UIView setAnimationDelegate:self];
        //    [UIView setAnimationDuration:0.01];
        cell.deleteButton.alpha = 1.0;
        cell.shareButton.alpha = 1.0;

    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        self.deleteButtonOnCell.alpha = 0.0;
        self.shareButtonOnCell.alpha = 0.0;
        [UIView commitAnimations];
    }
}

#pragma mark - Segue Stuff

-(IBAction)unwindToMyFaves:(UIStoryboardSegue *)segue {
    //from MapViewController && from InstaViewController
    InstaViewController *instaVC = segue.sourceViewController;
    for (Picture *picture in instaVC.favoritePictures) {
        [self.pictureURLStrings addObject:picture.imageURLString];
    }
    [self save];
    [self load];
    NSLog(@"unwind url count: %li", self.pictureURLStrings.count);

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 1) {
        [self performSegueWithIdentifier:@"InstaPhotosSegue" sender:item];
    }
}

#pragma mark - PLIST Stuff

-(void)load{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist"];
    self.pictureURLStrings = [NSMutableArray arrayWithContentsOfURL:plist] ?: [NSMutableArray new];
    NSLog(@"load count: %li", self.pictureURLStrings.count);
    [self.collectionView reloadData];
}

-(void)save {
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist"];
    [self.pictureURLStrings writeToURL:plist atomically:YES];
    NSLog(@"save count: %li", self.pictureURLStrings.count);
}

-(NSURL *)documentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

@end
