//
//  ViewController.m
//  Weather app
//
//  Created by Wan Muzaffar on 19/03/2021.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tempLbl;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLbl;
@property (weak, nonatomic) IBOutlet UILabel *humiditybl;
@property (weak, nonatomic) IBOutlet UILabel *pressureLbl;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLbl;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)searchPressed:(id)sender {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString *cityString = [self.cityTextField.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet];
    NSString *urlString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?q=%@&appid=9fd7a449d055dba26a982a3220f32aa2", cityString];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
     
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
       
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
               NSLog(@"Error: %@", error);
           } else {
               NSLog(@"%@ %@", response, responseObject);
          
               NSDictionary* responseDict = (NSDictionary*)responseObject;
               self.pressureLbl.text =
              [NSString stringWithFormat:@"%@ hpa",responseDict[@"main"][@"pressure"]];
               self.humiditybl.text =
              [NSString stringWithFormat:@"%@  %%",responseDict[@"main"][@"humidity"]];
               self.weatherLbl.text = responseDict[@"weather"][0][@"main"];
               double temp = [responseDict[@"main"][@"temp"] doubleValue] - 273.15;
               self.tempLbl.text = [NSString stringWithFormat:@"%.2f C", temp];
               
               NSDate *sunriseDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[responseDict[@"sys"][@"sunrise"] doubleValue]];
               
               NSDate *sunsetDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[responseDict[@"sys"][@"sunset"] doubleValue]];
               
               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
               [dateFormatter setDateFormat:@"hh:mm a"];
               self.sunsetLbl.text = [dateFormatter stringFromDate:sunsetDate];
               self.sunriseLbl.text = [dateFormatter stringFromDate:sunriseDate];
               
               NSString *imageIcon = responseDict[@"weather"][0][@"icon"];
               NSString *iconUrl = [NSString stringWithFormat:@"https://openweathermap.org/img/w/%@.png",imageIcon];
               [self.weatherImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
               
           }
        
    }];
    [dataTask resume];
    
}


@end
