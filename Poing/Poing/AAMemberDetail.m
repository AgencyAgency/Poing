//
//  AAMemberDetail.m
//  Poing
//
//  Created by Kyle Oba on 2/23/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAMemberDetail.h"

@implementation AAMemberDetail

+ (NSArray *)bios
{
    return @[@{@"name": @"Casey",
               @"bio": @"Casey is a senior at ‘Iolani School. She loves to run and is Captain of the ‘Iolani Girl’s Cross Country Team and has run varsity in cross country and track since her freshman year of high school. In the winter, Casey paddles for ‘Iolani Girls Varsity One Crew and loves spending time in the ocean. Casey is actively involved in activities and clubs around ‘Iolani as she is a Senior Prefect, Homecoming Co-Chair, ‘Iolani Fair Student Advisor, TV/Media Publicity Co-Chair for ‘Iolani Fair and Treasurer of the Chinese National Honors Society. Casey plans to attend college on the mainland when she graduates from ‘Iolani in June."},
             @{@"name": @"Eugene",
               @"bio": @"Eugene is a senior at ‘Iolani School. He finds himself spending a lot of time inside the room affectionately known as the “Bot Cave” after school during robotics meetings, as well as inside the Physics classrooms on Saturdays during Science Olympiad meetings. He enjoys watching videos on YouTube, reading manga, watching anime, folding origami, generally “wasting time” with his friends, and talking about himself in the third person (He said jokingly)."},
             @{@"name": @"Jordan",
               @"bio": @"Jordan is a junior who attends ‘Iolani school. He does many things with his free time but usually decides to spend it on sports. He has been wrestling for about five years now and has also been practicing judo for the same amount of time. He recently started a new sport, cross country, and also enjoys that as well. He is determined to do well this year at school, like getting good grades in his iPad App Design & Development class. He wishes to attend a college on the mainland after he graduates from ‘Iolani school."},
             @{@"name": @"Kristen",
               @"bio": @"Kristen is a junior at ‘Iolani School.  She enjoys playing soccer for both the school team and her outside club team.  She is also part of ‘Iolani's track team and runs sprints.  In her spare time, Kristen would probably be found hiking or swimming at the beach.  She would love to travel to New York, London, and Tahiti."},
             @{@"name": @"Roman",
               @"bio": @"Roman has a bit of experience in Java. Still, he doesn’t know all that much about programming in the real world at the moment. He has been taking piano for 10 years and karate for 4 years. Due to a so-far rough ‘Iolani career, he's narrowed down his classes to those pertinent to computers. He likes to play and mod games, cartoons (more anime than anything), sleep, and occasional hacking."},
             @{@"name": @"Shayna",
               @"bio": @"Shayna is a junior at ‘Iolani School. She enjoys playing soccer for her outside club team as well as bowling for the ‘Iolani bowling team. In her spare time, Shayna likes to shop and hang out with her friends. One day, she would like to travel across Europe and Japan. She would like to attend a mainland college after graduating from ‘Iolani."},
             @{@"name": @"Yuki",
               @"bio": @"Yuki is a senior at ‘Iolani School.  Yuki spent the better half of his high school in Cleveland, Ohio, where he participated in Varsity Soccer and Varsity Lacrosse.  In his free time he likes to spend time with his friends, shoot on a lacrosse goal, or educate himself on life skills.  He returned to playing water polo this year (had played in 8th grade) for fun but it ended up being more exhausting then he thought.  He aspires to work hard on the home stretch, and attend college abroad or on the mainland."},
             @{@"name": @"Cara",
               @"bio": @"Cara grew up wanting to be a scientist or inventor thanks to watching a lot of Mr. Wizard, Inspector Gadget, and Nova. She enjoys design and design research as it contains all the joys of hypothesis testing, wild ideas, creative problem solving, and building stuff within a social context. She wishes she had more time to do just about anything and everything. She finds time to play with family whenever possible and likely puts her daughter to bed far later than she should. "},
             @{@"name": @"Kyle",
               @"bio": @"Kyle enjoys programming. He also enjoys building software products and electronic things in general. He runs a software design studio with his wife, Cara, and spends a lot of time reading and drawing with his daughter. He enjoys watching movies and playing video games, but never has a chance to do either. Mostly, he passes his time grinding, brewing, and drinking coffee. He reads a lot of non-fiction, and loves unusual humor. He wishes he was in Paris."}
             ];
}

+ (NSString *)nameForBioInBios:(NSArray *)bios atIndex:(NSUInteger)index
{
    if (index >= [bios count]) return nil;
    return bios[index][@"name"];
}

+ (NSString *)descriptionForBioInBios:(NSArray *)bios atIndex:(NSUInteger)index
{
    if (index >= [bios count]) return nil;
    return bios[index][@"bio"];
}

@end
