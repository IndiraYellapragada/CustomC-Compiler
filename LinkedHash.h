//******************************
//  LinkedEntry Class Header
//LinkedEntry.h
//******************************

#include <string>
using namespace std;


class LinkedEntry {

private:
      string key;
      string value;
      string type;
      int loc;
      LinkedEntry *next;
public:
      LinkedEntry(string key,string value,string c,int l);   //Constructor
      string getKey();						   //Retrieves the key
      string getValue();					   //Retrieves the Value
      void setValue(string value);             //Sets the Value
      LinkedEntry *getNext() ;				   //Retrieves the next value of the linked list entry
      void setNext(LinkedEntry *next) ;        //Retrieves the next value of the linked list entry
      void setType(string c); 	//sets the Type 
      void setLoc(int l);
      string getType();
      int getLoc();
};
