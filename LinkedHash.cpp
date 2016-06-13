//******************************
//  LinkedEntry Class 
//LinkedEntry.cpp
//******************************

#include<string.h>
#include<iostream>
#include "LinkedHash.h"
using namespace std;
//Constructor. It initialises the key ,token name, type and location with the parameters passed
LinkedEntry::LinkedEntry(string key, string value,string c,int loc) {
    this->key = key;
    this->value = value;
    this->type=c;
    this->loc=loc;
    this->next = NULL;
}
 
//Retrieves the key
string LinkedEntry::getKey() {
    return key;
}
 
 //Retrieves the Value
string LinkedEntry::getValue() {
    return value;
}
 
//Sets the Value
void LinkedEntry::setValue(string value) {
    this->value = value;
}
 
//Retrieves the next value of the linked list entry
LinkedEntry *LinkedEntry::getNext() {
    return next;
}
 
//Retrieves the next value of the linked list entry
void LinkedEntry::setNext(LinkedEntry *next) {
    this->next = next;

}

//Sets the type of the linked list entry
void LinkedEntry::setType(string c) {
this->type=c;
}

//Gets the type of the LinkedEntry
string LinkedEntry::getType() {
return type;
}

//Sets the location for an linked list entry
void LinkedEntry::setLoc(int l) {
this->loc=l;
}

//Gets the location of an linked list entry
int LinkedEntry::getLoc() {
return loc;
}

