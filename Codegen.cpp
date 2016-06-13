#include "Codegen.h"
#include <iostream>
#include <sstream>
#include <string>
using namespace std;
Codegen::Codegen() {
codefile.open("CodeOutput.s");
curr_labelnum=0;
}
void Codegen::writeProlog()
{

codefile  << "#Prolog: "<<endl;
codefile  << ".text"<<endl;
codefile  << ".globl  main "<<endl;
codefile  << "main:"<<endl;
codefile  << "move  $fp  $sp"<<endl; 	
codefile  << "la  $a0  ProgBegin "<<endl;
codefile  << "li  $v0 4 "<<endl;
codefile  << "syscall "<<endl;
codefile  << "#End of Prolog"<<endl;

}
void Codegen::writePostlog()
{
codefile  << "#Postlog:"<<endl;
codefile  << "la $a0 ProgEnd"<<endl;
codefile  << "li $v0 4"<<endl;
codefile  << "syscall"<<endl;
codefile  << "li $v0 10 "<<endl; 	
codefile  << "syscall "<<endl;
codefile  << ".data "<<endl;
codefile  << "ProgBegin : .asciiz \"Program Begin\" \n "<<endl;
codefile  << "ProgEnd: .asciiz \"Program End\" \n "<<endl;
for(int i=0;i<curr_labelnum;i++)
{
  codefile  <<"Strlabel"<<i<<" : .asciiz  "<< array_string[i]<<endl;
}
codefile.close();
}
void Codegen :: writeCode(string str) {
       codefile  << str;
       codefile  << endl;
}

string Codegen::genStrlabel()
{
//static curr_labelnum=0;
string word="Strlabel";
       
	 stringstream str_token;
       str_token<<word<<curr_labelnum-1;

return str_token.str();
}

void Codegen::storeString_inarray(string s)
{
cout<<"string is"<<s;

array_string[curr_labelnum]=s;
curr_labelnum++;
cout<<"Value is"<<array_string[curr_labelnum];
}

string Codegen::getString_fromarray()
{
cout<<"GET"<<array_string[curr_labelnum-1];
return array_string[curr_labelnum-1];
}

string Codegen::genJumpLabel(string s)
{
static int cur=1;

stringstream strng;
strng<<"Label"<<s<<cur;
cur++;
return strng.str();
}

