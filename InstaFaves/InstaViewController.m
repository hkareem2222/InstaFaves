//
//  InstaViewController.m
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import "InstaViewController.h"
#import "InstaCollectionViewCell.h"
#import "Picture.h"

@interface InstaViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UISearchBar *tagSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableArray *pictureImages;
@property NSMutableArray *pictureURLs;
@property UIButton *selectedCellButton;
@property NSMutableArray *longitudes;
@property NSMutableArray *latitudes;
@property BOOL isSearchableByTags;
@end

@implementation InstaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setSelectedItem:self.tabBar.items[1]];
    self.tabBar.delegate = self;
    self.tagSearchBar.delegate = self;
    self.isSearchableByTags = YES;
    self.searchButton.titleLabel.text = @"Search by tags";
    self.favoritePictures = [NSMutableArray new];

    //sets searchbar to clear but then background turns black? from collectionview
//    self.tagSearchBar.barTintColor = [UIColor clearColor];
//    self.userSearchBar.barTintColor = [UIColor clearColor];

    //inital setup of Collection View
    //two parameters, customize by user input later, count & tags
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/tags/cars/media/recent?count=10&client_id=3acb27e236ad40d59bf2a83ae1bb9771"];
    [self apiCalled:url];
}

#pragma mark - API and storage of data

-(void)apiCalled:(NSURL *)url {
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *taggedMediaDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSArray *apiPictures = [taggedMediaDic objectForKey:@"data"];
        [self addToPictureObject:apiPictures];
    }];
}

-(void)addToPictureObject:(NSArray *)array {
    self.pictureImages = [NSMutableArray new];
    self.pictureURLs = [NSMutableArray new];
    self.latitudes = [NSMutableArray new];
    self.longitudes = [NSMutableArray new];

    for (NSDictionary *imagesDictionary in array) {
        NSDictionary *imageURLDictionary = [imagesDictionary objectForKey:@"images"];
        NSDictionary *locationDictionary = [imagesDictionary objectForKey:@"location"];
        NSLog(@"location: %@", locationDictionary);
        if (![locationDictionary isEqual:[NSNull null]]) {
            NSNumber *latitude = [locationDictionary objectForKey:@"latitude"];
            [self.latitudes addObject:latitude];
            NSNumber *longitude = [locationDictionary objectForKey:@"longitude"];
            [self.longitudes addObject:longitude];
        } else {
            NSNumber *zero = @0;
            [self.latitudes addObject:zero];
            [self.longitudes addObject:zero];
        }
        NSDictionary *standardResolutionDictionary = [imageURLDictionary objectForKey:@"standard_resolution"];
        NSString *urlString = [standardResolutionDictionary objectForKey:@"url"];
        [self.pictureURLs addObject:urlString];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        [self.pictureImages addObject:image];
    }
    [self.collectionView reloadData];
    [self.activityIndicator stopAnimating];
}

#pragma mark - Search Bar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (self.isSearchableByTags) {
        NSString *searchText = searchBar.text;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?count=10&client_id=3acb27e236ad40d59bf2a83ae1bb9771", searchText]];
        [self apiCalled:url];
    } else {
    }
}
- (IBAction)onSearchButtonTapped:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"Search by tags"]) {
        [button setTitle:@"Search by users" forState:UIControlStateNormal];
        self.isSearchableByTags = NO;
    } else {
        self.isSearchableByTags = YES;
        [button setTitle:@"Search by tags" forState:UIControlStateNormal];
    }
}




#pragma mark - CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictureImages.count;
}

-(InstaCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InstaCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageID" forIndexPath:indexPath];
    cell.imageView.image = self.pictureImages[indexPath.row];
    cell.heartButton.alpha = 0.0;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    InstaCollectionViewCell *cell = (InstaCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    //adding selected cell to object
    Picture *picture = [Picture new];
    picture.imageURLString = self.pictureURLs[indexPath.row];
    picture.latitude = self.latitudes[indexPath.row];
    picture.longitude = self.longitudes[indexPath.row];
    [self.favoritePictures addObject:picture];
    NSLog(@"favorite pics count: %li", self.favoritePictures.count);

    //animating UIButton on cell for favorite
    self.selectedCellButton = cell.heartButton;

    [UIView animateWithDuration:1.0 animations:^{
        cell.heartButton.alpha = 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            cell.heartButton.alpha = 0.0;
        }];
    }];
}

#pragma mark - Segue Stuff

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self performSegueWithIdentifier:@"unwindToMyFaves" sender:item];
    }
}
@end
