//******************************
//  Hash Map Class 
//HashMap.cpp
//******************************

#include "HashMap.h"
#include<iostream>
#include <string>
#include <sstream>
#include "ActiveBlocksStack.h"
using namespace std;


//Hash Map Constructor
//Creates 13 linked list entries and initialises
HashMap::HashMap() {							
	table = new LinkedEntry*[TABLE_SIZE];       

	for (int i = 0; i < TABLE_SIZE; i++)
	   table[i] = NULL;
}
 

//Active block number is concatenated with word is sent as parameter(key) and index location of the hash table
//Returns Empty string if key is not found. Returns Value of the key if found
string HashMap::find_current_block(string token,int active_block) {   
string key;
int hashindex;
HashMap hash_table;
key=concat_word_block(token,active_block);  //Active block num is concatenated with word
hashindex = hash_table.hash(key)   ;       		  	     

 if (table[hashindex] == NULL)
	 return "";
    else {
           LinkedEntry *entry = table[hashindex];
	while (entry != NULL && key !=entry->getKey())
              entry = entry->getNext();
            if (entry == NULL)
			 return "";
            else
			   return entry->getValue();
    }
}


//Active block number(present in the stack) is concatenated with word is sent as parameter(key)
//Returns Empty string if key is not found. Returns Value of the key if found

string HashMap::find_all(string token,int active_block) {
string key;
int i;

    ActiveBlocksStack *active_block_stack=new ActiveBlocksStack();


    for(i=active_block-1;i>=0;i--)
    {  
     key=concat_word_block(token,active_block_stack->get_stackvalue(i));
     for(int index=0;index<TABLE_SIZE;index++)
	{        
		LinkedEntry *entry = table[index];
		while (entry != NULL && key !=entry->getKey())
		entry = entry->getNext();
		if (entry != NULL)
	    	return entry->getValue();                  
	}
	
     }
    return "";
}
 
//Prints list of linked entries for specific index of hash table
void HashMap::print() {
ActiveBlocksStack *active_block_stack;

			for(int i=0;i<13;i++)                               //Prints the data of the hash table
			{
			if (table[i] != NULL)
       			{
            			LinkedEntry *entry = table[i];
				while (entry != NULL)
            			{	
				cout<<"Identifier is  "<< entry->getValue()<<" ";
				cout<<"Type is "<< entry->getType()<<" ";
        	             // cout <<entry->getLoc()<<" ";
				entry = entry->getNext();
				}
                         }

	}

}

//Inserts  token name,type and location  of identifier in hash table based on hash index
void HashMap::insert(string token,string type,int loc,int active_block) {
string key,value;
int hashindex;
HashMap hash_table;

key=concat_word_block(token,active_block);  //Active block num is concatenated with word
value=concat_word_block(token,active_block); 
hashindex = hash_table.hash(key)   ;


	if (table[hashindex] == NULL)
	{
	 
	table[hashindex] = new LinkedEntry(key,value,type,loc);
        }	
	else {
				LinkedEntry *entry = table[hashindex];
				while (entry->getNext() != NULL)
					entry = entry->getNext();                 
			
			entry->setNext(new LinkedEntry(key,value,type,loc));				 
	}
}
 

//Hash function will find the ascii value of each character in the token 
//And multiplies with length of token and takes mod of (size of hash table)
int HashMap::hash(string token)
{
    int value = 0;
	for ( int m = 0; m < token.length(); m++ )
			value += token[m];
return (value * token.length() ) % TABLE_SIZE;
}
      

//Deconstructor Deletes the entries after program terminates
HashMap::~HashMap() {
    for (int i = 0; i < TABLE_SIZE; i++)
            if (table[i] != NULL) 
			{
                LinkedEntry *prevEntry = NULL;
                LinkedEntry *entry = table[i];
                while (entry != NULL) 
				{
                        prevEntry = entry;
                        entry = entry->getNext();
                        delete prevEntry;
                }
            }
    delete[] table;

}
string HashMap::concat_word_block(string word, int block) 
{
	stringstream str_token;
	str_token<<word<<block;
return str_token.str();
}
