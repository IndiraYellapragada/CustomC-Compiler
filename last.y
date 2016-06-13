/**********************************
 * This is a Recursive Descent Parser for Baby C++ Language.
 * Parser parse the input file by using token numbers which are assigned
 * by the scanner. with every step it get the new token from scanner to 
 * work with. It get the new token after matching the current token. 
  * 
 * At any stage, if a mismatch occur then 'codegood'  value gets
 * changed to true. At the end of the parsing if value of 'codegood' is
 * false, then the parsing is done successfully and there is no parsing
 * error in the program.
 * If there occurs a parsing error in the program then it will terminate 
 * displaying a message "Syntax Error " 
 * But if non fatal errors are detected, like variable declaration missing
 * or multiple declarations of variables or cannot change constant's value, 
 * then it will continue parsing but will give non fatal error.
 
Program is written using bison and flex tools.
This is Parser program.Code is generated for each statement. Codegenerated is in MIPS Assembly Language
Filename of Codegeneration is CodeOutput.s


following commands are used to execute the program
flex lex.l
bison -d bison.y
g++ -o indu bison.tab.c lex.yy.c HashMap.cpp LinkedHash.cpp ActiveBlocksStack.cpp Codegen.cpp Codegen.h
./indu
***********************************/
%{
#include "Codegen.h" 							//Includes functions related to Codegen
#include "HashMap.h"							//Hash Table class
#include "ActiveBlocksStack.h"					//Includes ActiveBlocksStack class
#include <iostream>
#include <sstream>
#include <string>
using namespace std;


#define YYDEBUG 1
#define INTSIZE 4

int yylex(void);
void yyerror(char *);

bool codegood=true,found_token=false;
int i,CurrOff=0;
string jump_str;
int blck=0,active_block=0;



Codegen codegen;                                          		 //Creates Instance of Codegeneration class
ActiveBlocksStack* active_block_stack= new ActiveBlocksStack();   //Creates Instance of ActiveBlocksStack class
HashMap hash_table;												   //Creates Instance of HashMap class


char getType(string s);							// Returns the Type of identifier
string to_string(int i);						//Converts integer to string	
char* bool_as_text(bool);						// Converts boolean to char

%}

	
%union{	
int intval;										
char *strval; 
char charval;
struct expression{
				char type;						// Type of expression
				char *value;					// Value of expression
				int loc;						// Location
				}exrec;
};


// Tokens used in Baby C++ languages
%start mainstart
%token BEGINTOK  ENDTOK
%token <exrec> IDENTIFIER
%token NOTTOK ASSIGNTOK PROGTOK OP CP MAINTOK SEMICOLON MULTDIVTOK RD LD CINTOK COUTTOK  EOFTOK LITTOK STRLITTOK
%token <strval> DATATYPETOK
%token OPERATIONTOK  LOGICALOPERATOR ANDTOK ORTOK IFTOK ELSETOK WHILETOK COMMATOK  LB RB RETURNTOK

//Declaring the types of all the tokens and the non terminals
%type <exrec> id operation_stmt term arrayassign 
%type <exrec> LITTOK 
%type <exrec> ifstmt 
%type <exrec> factor function_arg
%type<strval> STRLITTOK
%type <strval> MULTDIVTOK 
%type <strval> OPERATIONTOK
%type <strval> LOGICALOPERATOR
%type <exrec> whileloopstmt
%type <exrec> express
%type <exrec> expprime
%type <exrec> termprime
%type <exrec> factorprime 
%type <exrec> relfactor
%%

mainstart   :{codegen.writeProlog();} func_protocol MAINTOK begin stmtlist end function_def {codegen.writePostlog();}   
			{ cout<<"1 	"; }
			
stmt        : function_call			  				 { cout<<"2	";}
			|cinstmt                                 { cout<<"3	";}
			|coutstmt                                { cout<<"4	";}
			|ifstmt                                  { cout<<"5	";}
			|whileloopstmt                           { cout<<"6	";}
			|declstmt 						   		 { cout<<"7 ";}
			|arraydecl                               { cout<<"8 ";}
			|assignment_list				 		 { cout<<"81 ";}
			|operation_stmt							 { cout <<"82 ";}
			|begin stmtlist end						 { cout<<"83 ";}
			|arrayassign							 {cout<<"84 ";}

stmtlist    :stmt stmtlist				 			{ cout<<"9 ";}
			|             			         		{ cout<< "91 ";}
			
cinstmt     :CINTOK RD id SEMICOLON          		{ cout<<"10	";}

coutstmt    :COUTTOK LD express SEMICOLON              { cout<<"11	";}
			|COUTTOK LD STRLITTOK SEMICOLON			{ cout<<"111";
				codegen.storeString_inarray($3);	//Stores the string in array
				codegen.writeCode("li $v0 4");
				codegen.writeCode("la $a0 "+codegen.genStrlabel());  //Generates string label 
				codegen.writeCode("syscall");}		//Prints the string
				
declstmt	:DATATYPETOK IDENTIFIER SEMICOLON			{ cout<<"12	"; 

				if(active_block_stack->IsEmpty()) active_block=blck;
                else active_block=active_block_stack->Top();            //Retrieves active block number
				hash_table.insert($2.value,$1,CurrOff,active_block);
				}
			|DATATYPETOK assignment_list			{cout<<"13 	";}


whileloopstmt   :WHILETOK OP express
				{
					jump_str=codegen.genJumpLabel("while");  //Generates whilejump label while1,while2 etc
					codegen.writeCode("inside whileloop");
					codegen.writeCode("lw $t0 "+to_string($3.loc)+"($fp)");
					codegen.writeCode("beq $t0 $zero end"+jump_str);
					codegen.writeCode(jump_str+":");
					codegen.writeCode("loop body");
					jump_str=codegen.genJumpLabel("while");
					codegen.writeCode("j "+jump_str);
				}
				CP begin stmtlist end 				{cout <<"15 ";}

express     :term expprime						{cout <<"61 ";}
expprime    :OPERATIONTOK term expprime 		{cout <<"62 ";
				string st;
				char *ch=$1;
			
				//Switch verifies if operation token is + or - and creates corresponding string
				switch(ch[0]){
							  case '+' : st="add"; break;
							  case '-':  st="sub"; break; 
							}		          	
					 
				codegen.writeCode("lw $t0 "+to_string($2.loc)+"($fp)");//CodeGen  lw of lop.loc into some register
				codegen.writeCode("lw $t1 "+to_string($$.loc)+"($fp)");//CodeGen  lw of er.loc into some other register
				codegen.writeCode(st+" $t0 $t0 $t1");//CodeGen  st of these two registers into some register
				codegen.writeCode("sw $t0 "+to_string(CurrOff)+"($fp)");//CodeGen  sw of this register into CurrentOffset and increment it by 4
				$$.type=$2.type;
				$$.loc= CurrOff;
				CurrOff-=4;
				}			
            |									{cout <<"63 ";}
term        :relfactor termprime				{cout <<"64 ";}
termprime   :MULTDIVTOK relfactor termprime		{cout <<"65 ";
				string  st;
				char *ch=$1;
				
				//Switch verifies if operation token is * or / and creates corresponding string
				switch(ch[0]){
							case '*' : st="mul";cout<<"here"; break;
							case '/':  st="div"; break;
													}
				if($3.type!=$$.type)
				{
				 codegen.writeCode("lw $t0 "+to_string($2.loc)+"($fp)");
				 codegen.writeCode("lw $t1 "+to_string($$.loc)+"($fp)");
				 codegen.writeCode(st+"$t0 $t0 $t1");
				 codegen.writeCode("sw $t0 "+to_string(CurrOff)+"($fp)");
				//$$.type=$2.type;
				//$$.loc= CurrOff;
				CurrOff-=4;
				}
			}
            |									{cout <<"66 ";}
relfactor   :factor factorprime					{cout <<"67 ";}
factorprime :LOGICALOPERATOR factor				{cout <<"68 ";
				if($2.type!=$$.type)
				{
				codegood=false;
				cout<<"Type mismatch 5";
				}
				else 
				{
				char *ch=$1;
				codegen.writeCode("lw $t0 "+to_string($2.loc)+"($fp)");
				codegen.writeCode("lw $t1 "+to_string($$.loc)+"($fp)");
				switch(ch[0]){
					case '<':codegen.writeCode("slt $t2 $t0 $t1");break;
				    case '>':codegen.writeCode("slt $t2 $t1 $t0");
					case '=':{		
							jump_str=codegen.genJumpLabel("label");	//Generates label1,label2 etc
							codegen.writeCode("beq $t0 $t1 "+jump_str);
							codegen.writeCode("li $t2 0");
							codegen.writeCode("j "+jump_str);
							codegen.writeCode(jump_str+":");
							}
					default: codegen.writeCode("slt $t2 $t0 $t1");
				}
				codegen.writeCode("sw $t2 "+to_string(CurrOff)+"($fp)");
				CurrOff-=4;
				}
			}
            |									{cout <<"69 ";}
factor      :NOTTOK factor						{cout <<"70 ";
			codegen.writeCode("lw $t0 "+to_string($2.loc)+"($fp)");
			codegen.writeCode("not $t1 $t0");  //for not operation
			codegen.writeCode("sw $t1 "+to_string(CurrOff)+"($fp)");
			CurrOff-=4;
			}
			|id									{cout <<"71 ";}
			|LITTOK    	{cout <<"72 ";
				if (getType($1.value)=='I')  // we have an integer literal like 523
				{
				 codegen.writeCode("li $t0 "+string($1.value));
				 codegen.writeCode("sw $t0 "+to_string(CurrOff)+"($fp)");//
				 $1.type= 'i';
				  $1.loc = CurrOff;
				CurrOff -= INTSIZE;
				}
				else{
				/*this will set the expression type and location to current 
				 * token's type and location. */
				$$.type=$1.type;
				$$.loc=$1.loc;
				$$.value=$1.value;
				}
			}
ifstmt      :IFTOK OP express CP
			{
				jump_str=codegen.genJumpLabel("if");	//Generates ifjump label if1,if2 etc
				codegen.writeCode("lw $t0 "+to_string($3.loc)+"($fp)");
				codegen.writeCode("beq $t0 $zero "+jump_str);
				codegen.writeCode(jump_str+":");
				codegen.writeCode("syscall");
				
			 jump_str=codegen.genJumpLabel("else"); 
			  codegen.writeCode("j "+jump_str);}
			 begin stmtlist end elsestmt 		{cout<<"16 ";}
				
elsestmt	:ELSETOK {codegen.writeCode(jump_str+":");}begin stmtlist end        
			{cout<<"17 	"; 								
				codegen.writeCode("syscall");
				codegen.writeCode("Endif:");	}
			|									{cout<<"18  ";}
				
				
assignment_list :assignment							{ cout<<"120	";}
				|assignment COMMATOK assignment_list{ cout<< "20	";}
				
assignment  :operation_stmt SEMICOLON    			{ cout<<"21	"; }

operation_stmt  :id ASSIGNTOK express  				{ cout<< "22	";
				if(getType($1.value)==getType($3.value))// Checks type of id and expression.Works only for integer value
					{		
					codegen.writeCode("li $v0 1");			
					codegen.writeCode("lw $t0 "+to_string($3.loc)+"($fp)");
					codegen.writeCode("sw $t0 "+to_string($1.loc)+"($fp)");
					codegen.writeCode("syscall");
					$$.type=$3.type;				//assigns type of expression to Top of Stack				
					$$.loc=$3.loc;					//assigns location of expression to Top of Stack
					$$.value=$3.value;
					}
				else codegood=false;
				}
				
arrayassign	:id LB LITTOK RB ASSIGNTOK express SEMICOLON
				{cout<<"23 ";
				if(getType($1.value)==getType($6.value))  // Checks type of id and expression.Works only for integer value
				{
				codegen.writeCode("li $v0 1");
				codegen.writeCode("lw $t0 "+to_string($6.loc)+"($fp)");
				codegen.writeCode("sw $t0 "+to_string($1.loc)+"($fp)");
				codegen.writeCode("syscall");
				$$.type=$6.type;						//assigns type of expression to Top of Stack
				$$.loc=$6.loc;							//assigns location of expression to Top of Stack
				}
				else codegood=false;
			}
			   
any_data_type_value_list:LITTOK			   						   		   {cout<<"29 ";}
						|LITTOK COMMATOK any_data_type_value_list          {cout<<"30 ";}
						
arraydecl       :DATATYPETOK IDENTIFIER LB LITTOK RB  SEMICOLON   { cout<<"31 ";
		if(active_block_stack->IsEmpty()) active_block=blck;
                else active_block=active_block_stack->Top();            //Retrieves active block number
		 hash_table.insert($2.value,$1,CurrOff,active_block);
                  }
                |DATATYPETOK IDENTIFIER LB LITTOK RB SEMICOLON ASSIGNTOK any_data_type_value_list  { cout<< "32 ";
		if(active_block_stack->IsEmpty()) active_block=blck;
                else active_block=active_block_stack->Top();            //Retrieves active block number
		 hash_table.insert($2.value,$1,CurrOff,active_block);
                }
				
function_def	:DATATYPETOK IDENTIFIER OP function_param CP begin stmt stmtlist RETURNTOK id SEMICOLON end 
				{cout <<"33	";
				if(active_block_stack->IsEmpty()) active_block=blck;
		                else active_block=active_block_stack->Top();            //Retrieves active block number
			         hash_table.insert($2.value,$1,CurrOff,active_block);
                                codegen.writeCode("addi $sp,$sp,"+to_string(CurrOff+4)); //Stack pointer value is incremented by 4
				codegen.writeCode("sw $t0,"+to_string(CurrOff)+"($sp)");					
				codegen.writeCode("add $v0 $t0 $0");		//Return value is stored into $v0
				codegen.writeCode("lw $t0, "+to_string(CurrOff)+"($sp) ");
				codegen.writeCode("addi $sp,$sp,"+to_string(CurrOff-4)); //Stack pointer value is decremented by 4
				}
				|	{cout<<"34	";}
				
func_protocol   :DATATYPETOK IDENTIFIER OP datatypelist CP SEMICOLON   { cout <<"40  ";}   //Grammar Function Protocol 
                |       {cout<<"41      ";}
				
datatypelist	:DATATYPETOK				{ cout <<"42	";}		// List of DATATYPETOK for Function Protocol
				| DATATYPETOK COMMATOK datatypelist {cout<<"43 ";}

function_call	:id ASSIGNTOK id OP function_arg
				{
				string funcLabel=codegen.genJumpLabel($3.value);
				codegen.writeCode("jal "+funcLabel);
				codegen.writeCode("syscall");		//Prints the return value of function
				codegen.writeCode("jr $ra");		//Returns to the return address stored in $ra
				codegen.writeCode(funcLabel+":");
				} CP SEMICOLON {cout<<"35";  } 	

function_arg	:LITTOK COMMATOK function_arg //Values of function arguments stored in $a0-$a2 by CodeGen
					{cout<<"549";
					codegen.writeCode("li $t0 "+string($1.value)); 
					codegen.writeCode("add $a2 $0 $t0");
					codegen.writeCode("li $t0 "+string($3.value));
					codegen.writeCode("add $a3 $0 $t0");					
					}
				|LITTOK  	
					{cout<<"548";  
					codegen.writeCode("li $t0 "+string($1.value));
					codegen.writeCode("add $a0 $0 $t0");
					}
				|id 
					{cout<<"547"; 
					codegen.writeCode("li $a0 "+string($1.value));
					}

function_param	:DATATYPETOK IDENTIFIER COMMATOK function_param {cout<<"550";if(active_block_stack->IsEmpty()) active_block=blck;
                else active_block=active_block_stack->Top();            //Retrieves active block number

		 hash_table.insert($2.value,$1,CurrOff,active_block);
                                }
				|DATATYPETOK IDENTIFIER        {cout<<"551";	if(active_block_stack->IsEmpty()) active_block=blck;
		                else active_block=active_block_stack->Top();            //Retrieves active block number
				 hash_table.insert($2.value,$1,CurrOff,active_block);
                                }


id			:	IDENTIFIER 
				{cout<<"335 	";
					$$.value=$1.value;   
					active_block=active_block_stack->Top();						
					if((hash_table.find_current_block($$.value,active_block))=="") //Checks if identifier is present is current block
					{
						found_token=false;
						if( hash_table.find_all($$.value,active_block)!="")  // if identifier not in active blocks checks in global values
						{
						found_token=true;
						break;
						}
					}
					else found_token= true;

					if(!found_token)
					cout<<"Error: Undeclared identifier: "<<$$.value;
						
					if (getType($1.value)=='I')  // Type,location is stored to Top of stack
					{
					$$.type=getType($1.value);
					$$.loc=CurrOff;				//Indu Check this if some error
					$$.value=$1.value;
					}  					
			    }

				
begin		:BEGINTOK 
			{cout<<"36  "; 
			active_block_stack->Push(blck++); 
			}

end			:ENDTOK
			{cout <<"37  ";
			active_block_stack->Pop(); }
%%



void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
}

//To_string method converts integer to string
string to_string(int i)
{
    stringstream ss;
    ss << i;
    return ss.str();
}


//getType method returns the type of token
char  getType(string s) {  
 
char ch; 
     
	for(int i=0;i<s.length();i++)
    {
		if(s[i]=='.') 
		{ch = 'f';
			return ch;	
		}
	}
      ch = 'I';
      return ch;
}

//This methods converts boolean to string
char* bool_as_text(bool b)
{
   stringstream converter;
    converter << b;
    return (char* )converter.str().c_str();
}

int main(void) {
    yyparse();
cout<<endl;
cout<<endl;
	if(!codegood)         /// If code has error, Codegen file generated is removed
	remove("CodeOutput.s");
	else
	{cout<<"      SYMBOL TABLE          "<<endl;
		hash_table.print();   //Prints the hash table
}
    return 0;
}

