//
// This Software (the "Software") is supplied to you by Openmind Networks
// Limited ("Openmind") your use, installation, modification or
// redistribution of this Software constitutes acceptance of this disclaimer.
// If you do not agree with the terms of this disclaimer, please do not use,
// install, modify or redistribute this Software.
//
// TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED ON AN
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
// EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
// CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Each user of the Software is solely responsible for determining the
// appropriateness of using and distributing the Software and assumes all
// risks associated with use of the Software, including but not limited to
// the risks and costs of Software errors, compliance with applicable laws,
// damage to or loss of data, programs or equipment, and unavailability or
// interruption of operations.
//
// TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW OPENMIND SHALL NOT
// HAVE ANY LIABILITY FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, WITHOUT LIMITATION,
// LOST PROFITS, LOSS OF BUSINESS, LOSS OF USE, OR LOSS OF DATA), HOWSOEVER
// CAUSED UNDER ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
// WAY OUT OF THE USE OR DISTRIBUTION OF THE SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGES.
//

//
//  ViewController.m
//  Battleship
//
//  Created by Sebastian Rosner on 20/11/2014.
//  Copyright (c) 2014 Sebastian Rosner. All rights reserved.
//

#import "ViewController.h"
#import "GOLGI_KEYS.h"

@interface ViewController (){
    NSArray *pList;
    NSUserDefaults *userDefaults;
    NSArray *tmpList;
}
@end

@implementation ViewController
@synthesize playerPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    pList = [[NSArray alloc] init];
    tmpList = [[NSArray alloc] init];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [myBattleshipSvc registerReachOutRequestHandler:^void(id<myBattleshipReachOutResultSender> resultsender, Battleship *myMsg2u)
     {
         NSLog(@"Message recieved %@", [myMsg2u getMyMsg]);
         
         [resultsender success];
     }];
        
    [myBattleshipSvc registerStartGameRequestHandler:^(id<myBattleshipStartGameResultSender> resultSender, PlayerInfo *playerInfo) {
        NSLog(@"Message recieved %@", [playerInfo getPList]);
        pList = [playerInfo getPList];
        [self buildPicker ];
        [resultSender success];
    }];
    
    [myBattleshipSvc registerNotifyPlayerInfoRequestHandler:^(id<myBattleshipNotifyPlayerInfoResultSender> resultSender, NSString *player) {
        NSLog(@"Message recieved %@", player);
        
        UIAlertView * alert = [[UIAlertView alloc]init];
        [alert setTitle:@"Battleships"];
        NSString * message = [NSString stringWithFormat:@"The Player %@ will play with you.",player];
        
        [alert setMessage:message];
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
        
        [resultSender success];
    }];
    
    self.startButton.hidden = NO;
}

- (void)showMainMenu:(NSNotification *)note {
    NSLog(@"Received Notification - Someone seems to have logged in");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)success
{
    NSLog(@"Message successfully sent!");
}

- (void)failureWithGolgiException:(GolgiException *)golgiException
{
    NSLog(@"Failed to send message %@", golgiException.getErrText);
}

- (IBAction)goToSetup:(id)sender {
    
    [userDefaults setObject:self.player1TextField.text
                     forKey:@"PLAYER1"];
    [userDefaults setObject:self.player2TextField.text
                     forKey:@"PLAYER2"];
    [userDefaults synchronize];
    
    [myBattleshipSvc sendNotifyPlayerInfoUsingResultReceiver:self andDestination:self.player2TextField.text withPlayer:self.player1TextField.text];
    
}

- (IBAction)textFieldValueChanged:(id)sender {
    NSLog(@"text changed %@ ",self.player1TextField.text);
    
    /*
    if(self.player1TextField.text.length >= 2){
        if (self.player2TextField.text.length >= 2) {
            self.startButton.hidden = NO;
        }
    } else {
        self.startButton.hidden = YES;
    }
     */
}

-(void)startGameWithResultSender:(id<myBattleshipStartGameResultSender>)resultSender andPlayerInfo:(PlayerInfo *)playerInfo{
    NSLog(@"startGameWithResultSender");
    pList = playerInfo.getPList;
}

- (IBAction)getPlayerList:(id)sender {
    NSLog(@"getPlayerList");
    NSString *p1 = self.player1TextField.text;
    
    NSLog(@"Golgi nameToRegister %@ ", p1);
    
    [Golgi registerWithDevId:GOLGI_DEV_KEY
                       appId:GOLGI_APP_KEY
                      instId:p1
            andResultHandler:^void(NSString *errText)
     {
         if(errText == nil) {
             NSLog(@"Golgi Registration: PASSED");
             PlayerInfo *playerInfo = [[PlayerInfo alloc] init];
             [playerInfo setName:p1];
             
             [playerInfo setPList:tmpList];
             
             [myBattleshipSvc sendStartGameUsingResultReceiver:self andDestination:@"BS" withPlayerInfo:playerInfo];
         } else {
             NSLog(@"Golgi Registration: FAIL => '%s'", [errText UTF8String]);
         }
     }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//
// Registration worked
//
- (void)golgiRegistrationSuccess
{
    NSLog(@"Golgi Registration: PASSED");
    
    // Disable Register button and register text after first Registration
}

//
// Registration failed
//
- (void)golgiRegistrationFailure:(NSString *)errorText
{
    NSLog(@"Golgi Registration: FAIL => '%@'", errorText);
}


// player picker view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pList count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [self.player2TextField setText:[pList objectAtIndex:row]];
    return [pList objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@" picker item : %@",[pList objectAtIndex:row]);
}

-(void)buildPicker
{
    playerPickerView.delegate = self;
    playerPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:playerPickerView];
}

@end