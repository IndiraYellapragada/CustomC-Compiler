//******************************
//  Hash Map Class Header
//HashMap.h
//******************************

#include "LinkedHash.h"
//#include "ActiveBlocksStack.h"
const int TABLE_SIZE = 13;         //Assuming a Maximum Variables declared will be 40
 
class HashMap {
private:
      LinkedEntry **table;         //Creates hash table of linked lists
  //   ActiveBlocksStack *active_block_stack; //Creates stack of Active blocks
public:
      HashMap() ; 
      string find_current_block(string key,int hashindex) ; //Finds key in speci 
 string find_all(string key,int block) ;  //Finds key in the entire hash table
	  void print() ;  
     void insert(string token,string type,int loc,int active_block);  //Inserts key at spec
 int hash(string token);                               //hash function
      ~HashMap() ;	
string concat_word_block(string word, int block); 
};
