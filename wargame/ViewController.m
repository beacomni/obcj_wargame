//
//  ViewController.m
//  wargame
//
//  Created by beacomni on 6/20/17.
//  Copyright © 2017 beacomni. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *TurnButton;
@property (strong, nonatomic) IBOutlet UIImageView *Player2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *Player1ImageView;

@property NSMutableArray *Player1Cards;
@property NSMutableArray *Player2Cards;

@property NSMutableArray *deck;

@property (strong,nonatomic) NSString *spade;
@property (strong,nonatomic) NSString *heart;
@property (strong,nonatomic) NSString *diamond;
@property (strong,nonatomic) NSString *club;

@property (strong, nonatomic) IBOutlet UILabel *Player1CardCount;
@property (strong, nonatomic) IBOutlet UILabel *Player2CardCount;
@property (strong, nonatomic) IBOutlet UILabel *Player1CardLabel;
@property (strong, nonatomic) IBOutlet UILabel *Player2CardLabel;
@property (strong, nonatomic) IBOutlet UILabel *GameOverLabel;
@property (strong, nonatomic) IBOutlet UIButton *ResetButton;
@property (strong, nonatomic) IBOutlet UILabel *Player1SuitLabel;
@property (strong, nonatomic) IBOutlet UILabel *Player2SuitLabel;

@property (strong, nonatomic) NSMutableArray *rankToFaceNumber;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *Player2DeckSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *Player1DeckSwipeRecognizer;

- (void )DoTurn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setup];
    
    UISwipeGestureRecognizer *swipeRecognizer;
    
    /*_Player2DeckSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DoTurn)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRecognizer.cancelsTouchesInView = YES;*/
    
    /*_Player1DeckSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(DoTurn)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRecognizer.cancelsTouchesInView = YES;*/
    
}

#pragma mark
/////////////gestures

////////////////
#pragma mark
//main imple
- (NSMutableArray *) InitDeck{
    NSMutableArray *spades = [self createSuit:_spade];
    NSMutableArray *clubs= [self createSuit:_club];
    NSMutableArray *diamonds = [self createSuit:_diamond];
    NSMutableArray *hearts = [self createSuit:_heart];
    
    NSMutableArray *deck = [[NSMutableArray alloc] init];
    [deck addObjectsFromArray:spades];
    [deck addObjectsFromArray:hearts];
    [deck addObjectsFromArray:diamonds];
    [deck addObjectsFromArray:clubs];
    
    return deck;
}

- (NSMutableArray *) createSuit:(NSString *)suit{
    NSMutableArray *suitarr = [[NSMutableArray alloc] init];
    for(int i = 0; i < 13; i++){
        Card *card = [[Card alloc] init];
        card.suit = suit;
        card.rank = i;
        //todo names;
        card.name = @"Queen";
        [suitarr addObject:card];
    }
    return suitarr;
}

- (NSMutableArray *)ShuffleDeck:(NSMutableArray *)deck{
    for (NSUInteger i = 0; i < deck.count - 1; ++i) {
        NSInteger remainingCount = deck.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [deck exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return deck;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)HandleTurnClick:(id)sender {
    [self DoTurn];
}

- (IBAction)Player1DeckSwipeRecognizerHandle:(id)sender {
    [self DoTurn];
}
- (IBAction)Player2DeckSwipeRecognizer:(id)sender {
    [self DoTurn];
}

- (void) DoTurn{
    if(_Player1Cards.count == 0 || _Player2Cards.count == 0){
        [self GameEnd];
    }
    Card *player1Card = (Card *)_Player1Cards[0];
    [_Player1Cards removeObjectAtIndex:0];
    [_Player1CardLabel setText:_rankToFaceNumber[player1Card.rank]];
    [_Player1SuitLabel setText:player1Card.suit];
    
    Card *player2Card = (Card *)_Player2Cards[0];
    [_Player2Cards removeObjectAtIndex:0];
    [_Player2CardLabel setText:_rankToFaceNumber[player2Card.rank]];
    [_Player2SuitLabel setText:player2Card.suit];
    
    if(player1Card.rank > player2Card.rank){
        [_Player1Cards addObject:player1Card];
        [_Player1Cards addObject:player2Card];
    }
    else if(player1Card.rank < player2Card.rank){
        [_Player2Cards addObject:player1Card];
        [_Player2Cards addObject:player2Card];
    }
    else{
        [_Player1Cards addObject:player1Card];
        [_Player2Cards addObject:player2Card];
    }
    [_Player1CardCount setText:[NSString stringWithFormat:@"%lu", (unsigned long)_Player1Cards.count]];
    [_Player2CardCount setText:[NSString stringWithFormat:@"%lu", (unsigned long)_Player2Cards.count]];
}

- (void) GameEnd{
    [_Player1CardLabel setText:@""];
    [_Player2CardLabel setText:@""];
    [_GameOverLabel setText:@"Good Game"];
}

- (IBAction)ResetButtonHandle:(id)sender {
    [self setup];
}

- (void) setup{
    _spade = @"spade";
    _heart = @"heart";
    _club = @"club";
    _diamond = @"diamond";
    
    [_Player1SuitLabel setText:@""];
    [_Player2SuitLabel setText:@""];
    [_Player1CardLabel setText:@""];
    [_Player2CardLabel setText:@""];
    
    //todo shuffle
    _deck = [self InitDeck];
    _deck = [self ShuffleDeck:_deck];
    NSRange firstHalf = NSMakeRange(0,_deck.count/2);
    NSRange secondHalf = NSMakeRange(_deck.count/2,_deck.count/2);
    _Player1Cards = [[_deck subarrayWithRange:firstHalf] mutableCopy];
    _Player2Cards = [[_deck subarrayWithRange:secondHalf] mutableCopy];
    
    [_Player1CardCount setText:[NSString stringWithFormat:@"%lu", (unsigned long)_Player1Cards.count]];
    [_Player2CardCount setText:[NSString stringWithFormat:@"%lu", (unsigned long)_Player2Cards.count]];
    _rankToFaceNumber = [[NSMutableArray alloc] init];
    _rankToFaceNumber[0] = @"2";
    _rankToFaceNumber[1] = @"3";
    _rankToFaceNumber[2] = @"4";
    _rankToFaceNumber[3] = @"5";
    _rankToFaceNumber[4] = @"6";
    _rankToFaceNumber[5] = @"7";
    _rankToFaceNumber[6] = @"8";
    _rankToFaceNumber[7] = @"9";
    _rankToFaceNumber[8] = @"10";
    _rankToFaceNumber[9] = @"jack";
    _rankToFaceNumber[10] = @"queen";
    _rankToFaceNumber[11] = @"king";
    _rankToFaceNumber[12] = @"ace";
    
}




@end
