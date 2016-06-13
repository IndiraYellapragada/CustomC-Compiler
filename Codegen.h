#include <fstream>
#include <string>
using namespace std;
class Codegen {
private:
      ofstream codefile;
public:
      string array_string[10];
      int curr_labelnum; 
	Codegen();
void   writeProlog();
void   writePostlog();
void   writeCode(string);
void   storeString_inarray(string);
string  getString_fromarray();
string genStrlabel();
string genJumpLabel(string);
};

