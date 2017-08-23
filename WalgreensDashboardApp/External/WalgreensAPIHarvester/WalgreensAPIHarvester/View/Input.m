//
//  Input.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "Input.h"

@implementation Input

- (void)flush {
    int c;
    while ((c = getchar()) != EOF && c != '\n');
}

- (BOOL)confirmWithQuestion:(char *)question {
    while (1) {
        printf("%s (y/n): ", question);
        char option;
        scanf("%c", &option);
        [self flush];
        switch (option) {
            case 'y':
                printf("Ok\n");
                printf("\n");
                return YES;
                break;
            case 'n':
                printf("\n");
                return NO;
                break;
            default:
                printf("Invalid input\n");
                printf("\n");
                break;
        }
    }
}

@end
