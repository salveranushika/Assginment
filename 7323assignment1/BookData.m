
#import <Foundation/Foundation.h>
@implementation BookData : NSObject 

+ (NSArray *)getBooks {
    // To Obtain path for JSON file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"books" ofType:@"json"];
    
    // To Load JSON data
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    // To Parse JSON data
    NSError *error;
    NSArray *booksArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"Error reading JSON file: %@", error.localizedDescription);
        return @[];
    }
    
    return booksArray;
}


@end
