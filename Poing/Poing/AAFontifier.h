//
//  AAFontifier.h
//  Poing
//
//  Created by Kyle Oba on 1/21/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAFontifier : NSObject

+ (NSAttributedString *)highlightTodayInString:(NSString *)string forFont:(UIFont *)font;

@end
