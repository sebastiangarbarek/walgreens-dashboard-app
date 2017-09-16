//
//  StoreCategoryController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreCategoryController.h"

@implementation StoreCategoryController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [self updateView];
}

#pragma mark - Container View Methods -

- (void)updateView {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        // List.
        [self remove:self.mapController];
        
        // Pass data here.
        
        [self add:self.listController];
    } else {
        // Map.
        [self remove:self.listController];
        
        // Pass data here.
        
        [self add:self.mapController];
    }
}

- (void)add:(UIViewController *)viewController {
    // Add as child view controller to this view controller.
    [self addChildViewController:viewController];
    
    // Add the view as a subview to the container view, sizing appropriately.
    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
    
    // Etiquette. Queue to refresh view.
    [viewController didMoveToParentViewController:self];
}

- (void)remove:(UIViewController *)viewController {
    // Etiquette.
    [viewController willMoveToParentViewController:nil];
    
    // Remove the view from the container view.
    [viewController.view removeFromSuperview];
    
    // Remove the view from controller.
    [viewController removeFromParentViewController];
}

#pragma mark - Custom Get Methods -

- (UIViewController *)listController {
    if (!_listController) {
        // Load storyboard.
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"StoreCategory" bundle:nil];
        
        // Instantiate view controller.
        _listController = [storyBoard instantiateViewControllerWithIdentifier:@"List"];
        
        // First list controller will always be a StoreStateController.
        ((StoreStateController *)_listController).segueDelegate = self;
    }
    
    return _listController;
}

- (UIViewController *)mapController {
    if (!_mapController) {
        // Load storyboard.
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"StoreCategory" bundle:nil];
        
        // Instantiate view controller.
        _mapController = [storyBoard instantiateViewControllerWithIdentifier:@"Map"];
    }

    return _mapController;
}

#pragma mark - Navigation Methods -

- (IBAction)selectionDidChange:(id)sender {
    [self updateView];
}

- (void)child:(UIViewController *)viewController didCallSegueWithIdentifier:(NSString *)identifier {
    [self performSegueWithIdentifier:identifier sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"State Cities"]) {
        // Safe cast to StoreStateController due to identifier guard.
        StoreStateController *storeStateController = ((StoreStateController *)_listController);
        NSIndexPath *indexPath = storeStateController.tableView.indexPathForSelectedRow;
        
        StoreCityController *storeCityController = [segue destinationViewController];
        // Retrieve and pass state abbreviation.
        storeCityController.state = [[storeStateController.cellsToSectionAbbr
                                      objectForKey:[storeStateController.sectionTitles objectAtIndex:indexPath.section]]
                                     objectAtIndex:indexPath.row];
    }
}

@end
