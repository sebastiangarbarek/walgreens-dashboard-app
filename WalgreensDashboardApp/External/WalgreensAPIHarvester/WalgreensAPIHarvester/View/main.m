//
//  main.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Input.h"
#import "DataController.h"
#import "StatusController.h"

void header() {
    printf("  ,--./,-.\n");
    printf(" / #      \\\n");
    printf("|          |\n");
    printf(" \\        /Walgreens API Harvester\n");
    printf("  `._,._,'=======================\n");
    printf("\n");
}

void menu() {
    header();
    printf("Main menu:\n");
    printf("1) Create store database\n");
    printf("2) Update store statuses\n");
    printf("3) Download product data\n");
    printf("4) Exit\n");
    printf("\n");
    printf("Enter option: ");
}

void returningMenu() {
    header();
    printf("Main menu:\n");
    printf("1) Create store database\n");
    printf("2) Update store statuses\n");
    printf("3) Download product data\n");
    printf("4) Exit\n");
    printf("\n");
    printf("Incomplete store table detected!\n");
    printf("5) Complete store database\n");
    printf("\n");
    printf("Enter option: ");
}

BOOL execute() {
    Input *input = [[Input alloc] init];
    
    while (1) {
        DataController *temp = [[DataController alloc] init];
        NSArray *missingStores = [temp isStoreDataIncomplete];
        
        (missingStores) ? returningMenu() : menu();
        
        temp = nil;
        
        int option = 0;
        scanf("%d", &option);
        [input flush];
        switch (option) {
            case 1: {
                printf("\n");
                if ([input confirmWithQuestion:"This will overwrite any existing store data, are you sure?"]) {
                    DataController *dataController = [[DataController alloc] init];
                    [dataController requestAndInsertAllStoreData];
                    [dataController closeDatabase];
                    printf("\n");
                }
                break;
            }
            case 2: {
                printf("\n");
                StatusController *statusController = [[StatusController alloc] init];
                [statusController updateStoreStatusesForToday];
                [statusController closeDatabase];
                printf("\n");
                break;
            }
            case 3: {
                printf("\n");
                if ([input confirmWithQuestion:"This will overwrite any existing product data, are you sure?"]) {
                    DataController *dataController = [[DataController alloc] init];
                    [dataController requestAndInsertAllProductData];
                    [dataController closeDatabase];
                    printf("\n");
                }
                break;
            }
            case 4:
                printf("Goodbye\n");
                printf("\n");
                return NO;
                break;
            case 5: {
                if (missingStores) {
                    printf("\n");
                    DataController *dataController = [[DataController alloc] init];
                    [dataController requestAndInsertAllStoreDataWithList:missingStores];
                    [dataController closeDatabase];
                    printf("\n");
                    break;
                }
            }
            default:
                printf("Invalid input\n");
                printf("\n");
                break;
        }
        
        printf("Checking store database...\n");
        printf("\n");
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        while (execute() != NO);
    }
    return 0;
}
