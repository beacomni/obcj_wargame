//
//  Card.h
//  wargame
//
//  Created by beacomni on 6/20/17.
//  Copyright © 2017 beacomni. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Card : NSObject

@property NSString *suit;
@property int rank;
@property (strong, nonatomic) NSString *name;

@end

