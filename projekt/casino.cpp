#include <iostream>
#include <queue>
#include <thread>
#include <random>

using namespace std;
using namespace this_thread;

const int NUMBER_OF_FEEDERS = 2;
const int NUMBER_OF_CARDS = 52;

struct Card {
    int suit; //Przyjeto: 0: pik, 1: kier, 2: karo, 3: trefl
    int rank; //Przyjeto: 1: as, 2-10: std, 11: jupek, 12: dama, 13: krol
    string cardToString(){
        string returnString = "card:";

        switch(rank){
            case 1: 
                returnString += " Ace";
                break;
            case 11: 
                returnString += " Jack";
                break;
            case 12: 
                returnString += " Queen";
                break;
            case 13: 
                returnString += " King";
                break;
            default: returnString += " " + to_string(rank);
        }

        switch(suit){
            case 0: 
                returnString += " of spades";
                break;
            case 1: 
                returnString += " of hearts";
                break;
            case 2: 
                returnString += " of diamonds";
                break;
            case 3: 
                returnString += " of clubs";
                break;
        }

        return returnString;
    }
};


queue<Card> buffer;
bool stop_threads = false;

void feeder(int id){
    printf("Starting feeder\n");

    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<int> suit_dist(0, 3); 
    uniform_int_distribution<int> rank_dist(1, 13);

    for(int i = 0; i <  NUMBER_OF_CARDS; i++){
        Card card;
        card.suit = suit_dist(gen);
        card.rank = rank_dist(gen);
        // cout<< "Card feeder " << id << " produces " << card.cardToString() << endl;
        printf("Card feeder %d, produces card: suit %d, rank %d\n", id, card.suit, card.rank);
        buffer.push(card);
    }

}

void dealer(){
    printf("Starting dealer\n");

    int count = 0; //liczba pobranych kart

    while(true){

        if(stop_threads && buffer.empty() && count == NUMBER_OF_CARDS) break;

        if(!buffer.empty()){
            Card card = buffer.front();
            buffer.pop();
            cout << "Dealer consumes " << card.cardToString() << endl;
            count++;
        }else{
            static int number_of_finished_feeders = 0;
            if(++number_of_finished_feeders == NUMBER_OF_FEEDERS){
                stop_threads = true;
                break;
            }
        }
    }
}

int main(){

    //Start
    printf("\n!Initialize casino!\n");

    // Tworzenie tabele watkow podajników kart na podstawie stalej skryptu
    // w etapie 1, uwzgledniany jest tylko 1 podajnik
    thread feeders[NUMBER_OF_FEEDERS];
    for(int i = 0; i< NUMBER_OF_FEEDERS; i++){
        feeders[i] = thread(feeder,i);
    }

    thread dealer_thread(dealer);

    for(int i = 0; i<NUMBER_OF_FEEDERS; i++){
        feeders[i].join();
    }
    dealer_thread.join();

    printf("\n!End casino!\n");
    return 0;
}