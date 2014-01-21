//
//  AAFontifier.m
//  Poing
//
//  Created by Kyle Oba on 1/21/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAFontifier.h"

@implementation AAFontifier

+ (NSAttributedString *)highlightTodayInString:(NSString *)string forFont:(UIFont *)font
{
    if (![string length]) return nil;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange todayRange = [string rangeOfString:@"Today:"];
    if (todayRange.location != NSNotFound) {
        UIFontDescriptor *fontDescriptor = [font fontDescriptor];
        fontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        UIFont *boldFont = [UIFont fontWithDescriptor:fontDescriptor size:fontDescriptor.pointSize];
        
        NSMutableDictionary *attrs =
        [NSMutableDictionary
         dictionaryWithDictionary:@{NSBackgroundColorAttributeName: [UIColor magentaColor],
                                    NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        // Only add bold if will let you. Otherwise, it would return a nil font.
        if (boldFont) [attrs setObject:boldFont forKey:NSFontAttributeName];
        [text setAttributes:attrs range:todayRange];
    }
    return text;
}

@end
