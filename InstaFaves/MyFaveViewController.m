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
#import "MapViewController.h"
#import <MessageUI/MessageUI.h>

@interface MyFaveViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate, FaveCollectionViewCellDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property NSMutableArray *pictureURLStrings;
@property NSMutableArray *pictureLatitudes;
@property NSMutableArray *pictureLongitudes;
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
    cell.delegate = self;
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

        [UIView animateWithDuration:1.0 animations:^{
            cell.deleteButton.alpha = 1.0;
            cell.shareButton.alpha = 1.0;
        }];

    } else {
        [UIView animateWithDuration:1.0 animations:^{
            cell.deleteButton.alpha = 0.0;
            cell.shareButton.alpha = 0.0;
        }];

    }
}

-(void)faveCollectionViewCell:(FaveCollectionViewCell *)cell didTapDeleteButton:(UIButton *)button {
    NSLog(@"called");
    [self.pictureURLStrings removeObjectAtIndex:[[self.collectionView indexPathForCell:cell] row]];
    [self.pictureLatitudes removeObjectAtIndex:[[self.collectionView indexPathForCell:cell] row]];
    [self.pictureLongitudes removeObjectAtIndex:[[self.collectionView indexPathForCell:cell] row]];
    cell.deleteButton.alpha = 0.0;
    cell.shareButton.alpha = 0.0;
    [self save];
    [self.collectionView reloadData];
}

-(void)faveCollectionViewCell:(FaveCollectionViewCell *)cell didTapShareButton:(UIButton *)button {


//    NSString *text = @"How to add Facebook and Twitter sharing to an iOS app";
//    NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
    UIImage *image = cell.imageView.image;

    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[image]
     applicationActivities:nil];

    [self presentViewController:controller animated:YES completion:nil];
    cell.deleteButton.alpha = 0.0;
    cell.shareButton.alpha = 0.0;
}



#pragma mark - Segue Stuff

-(IBAction)unwindToMyFaves:(UIStoryboardSegue *)segue {
    //from MapViewController && from InstaViewController

    if ([segue.identifier isEqualToString:@"unwindToMyFaves"]) {
        InstaViewController *instaVC = segue.sourceViewController;
        for (Picture *picture in instaVC.favoritePictures) {
            [self.pictureURLStrings addObject:picture.imageURLString];
            [self.pictureLatitudes addObject:picture.latitude];
            [self.pictureLongitudes addObject:picture.longitude];
        }
        [self save];
        [self load];
        NSLog(@"unwind url count: %li", self.pictureURLStrings.count);
    }

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 1) {
        [self performSegueWithIdentifier:@"InstaPhotosSegue" sender:item];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMap"]) {
        MapViewController *mapVC = [segue destinationViewController];
        mapVC.latitudes = self.pictureLatitudes;
        mapVC.longitudes = self.pictureLongitudes;
        mapVC.pictureURLs = self.pictureURLStrings;
    }
}

#pragma mark - PLIST Stuff
//CONVERT TO USER DEFAULTS
-(void)load{
    //loading url
    NSURL *plistURL = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist"];
    self.pictureURLStrings = [NSMutableArray arrayWithContentsOfURL:plistURL] ?: [NSMutableArray new];

    //loading latitude
    NSURL *plistLatitude = [[self documentsDirectory] URLByAppendingPathComponent:@"pastesLatitude.plist"];
    self.pictureLatitudes = [NSMutableArray arrayWithContentsOfURL:plistLatitude] ?: [NSMutableArray new];

    //loading longitude
    NSURL *plistLongitude = [[self documentsDirectory] URLByAppendingPathComponent:@"pastesLongitude.plist"];
    self.pictureLongitudes = [NSMutableArray arrayWithContentsOfURL:plistLongitude] ?: [NSMutableArray new];

    [self.collectionView reloadData];
}

-(void)save {
    //saving url
    NSURL *plistURL = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes.plist"];
    [self.pictureURLStrings writeToURL:plistURL atomically:YES];

    //saving latitude
    NSURL *plistLatitude = [[self documentsDirectory] URLByAppendingPathComponent:@"pastesLatitude.plist"];
    [self.pictureLatitudes writeToURL:plistLatitude atomically:YES];

    //saving longitude
    NSURL *plistLongitude = [[self documentsDirectory] URLByAppendingPathComponent:@"pastesLongitude.plist"];
    [self.pictureLongitudes writeToURL:plistLongitude atomically:YES];
}

-(NSURL *)documentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}
@end
