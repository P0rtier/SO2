#include <iostream>
#include <queue>
#include <thread>
#include <random>
#include <mutex>
#include <condition_variable>

using namespace std;
using namespace this_thread;
using namespace std::chrono;

const int NUMBER_OF_FEEDERS = 4;
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
// Wprowadzenie mutexu w celu poprawy synchronizacji, zapobieganie wyscigom
mutex buffer_mutex;
//Zmienna warunkowa poprawia synchronizacje, inicjalizuje warunek stopu
condition_variable buffer_cv;
int finished_feeders = 0;
//Bezwzgledny warunek stopu
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

        unique_lock<mutex> lock(buffer_mutex);
        buffer_cv.wait(lock, [] {return buffer.size() < NUMBER_OF_FEEDERS || stop_threads; });

        if(stop_threads) break;
        cout<< "Card feeder " << id << " produces " << card.cardToString() << endl;
        // printf("Card feeder %d, produces card: suit %d, rank %d\n", id, card.suit, card.rank);
        buffer.push(card);
        // Odblokowanie mutexu
        lock.unlock();
        // Powiadomienie watku konsumera
        buffer_cv.notify_one();
    }

    {
        // Mutex guarda nadzorujacy ewentualny warunek stopu
        lock_guard<mutex> lock(buffer_mutex);
        finished_feeders++;
        if(finished_feeders == NUMBER_OF_FEEDERS){
            stop_threads=true;
            buffer_cv.notify_one();
        }
    }

}

void dealer(){
    printf("Starting dealer\n");

    int count = 0; //liczba pobranych kart

    while(true){

        unique_lock<mutex> lock(buffer_mutex);

        buffer_cv.wait(lock, [] {return !buffer.empty() || (stop_threads && finished_feeders == NUMBER_OF_FEEDERS); });

        if(stop_threads && buffer.empty() && count == NUMBER_OF_CARDS * NUMBER_OF_FEEDERS) break;

        if(!buffer.empty()){
            Card card = buffer.front();
            buffer.pop();
            cout << "Dealer consumes " << card.cardToString() << endl;
            count++;
            lock.unlock();
            buffer_cv.notify_one();
        }else{
            static int number_of_finished_feeders = 0;
            if(++number_of_finished_feeders == NUMBER_OF_FEEDERS){
                stop_threads = true;
                lock.unlock();
                break;
            }
            lock.unlock();
        }
    }
}

int main(){

    //Start
    printf("\n!Initialize casino!\n");

    // Tworzenie tabele watkow podajnikow kart na podstawie stalej skryptu
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

    buffer_cv.notify_all();

    printf("\n!End casino!\n");
    return 0;
}