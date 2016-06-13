/****************************************************************************************
This is Scanner Program which is LEx like Program 
This file has all the rules for BabyC++ language represented in Regular Expressions.
 It takes file that has program which is written in BabyC++ Language  as input 
It scans the entire file and each token is categorised based on the rules in this file.
This program  returns output that prints what each token is.
****************************************************************************************/ 

%{
#include "bison.tab.h"/* include c++ i/o routines */
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
using namespace std;
int NOTTOK=12;
int MAINTOK=4;
%}    
LETTER [a-zA-Z]
DIG [0-9]
MAINTOK "void main()"
ID    [a-zA-Z][a-zA-Z0-9]*
LETTER_OR_DIG [a-zA-Z0-9# 
STRING \"{LETTER_OR_DIG}\"
COMPARISON_OPERATOR "<"|">"
OPERATOR "+"|"-"
MULTDIVTOK "*"|"/"
STRLITTOK \"(\\.|[^"])*\"  
DATATYPE "int|float|string";}
NOTTOK "!"
%option noyywrap

%%
"void main()"   { return MAINTOK;}
"{"				{ return BEGINTOK;}
"}"		        { return ENDTOK ;}
"("             { return OP;}
")"             { return CP;}
"["				{ return LB;}
"]"				{ return RB;}
"="             {return ASSIGNTOK;}
";"				{return SEMICOLON;}
"<<"			{ return LD;}
">>"			{return RD;}
"cin"			{ return CINTOK;}
"cout"			{ return COUTTOK;}
"and"			{ return ANDTOK;}
"or"			{ return ORTOK;}
"if"			{ return IFTOK;}
"else"			{ return ELSETOK;}
"while"			{ return WHILETOK;}
"return"		{ return RETURNTOK;}
"!"				{ return NOTTOK;}
","				{ return COMMATOK;}
"int"|"float"|"string"  { yylval.strval=strdup(yytext);return DATATYPETOK;}
"+"|"-"			{ yylval.strval=strdup(yytext);return OPERATIONTOK;}
"*"|"/"			{ yylval.strval=strdup(yytext);return MULTDIVTOK;}
 "<"|">"		{ yylval.strval=strdup(yytext);return LOGICALOPERATOR;}
[0-9]+|[0-9]+.[0-9]+    {yylval.exrec.value=strdup(yytext); return LITTOK;}
\"(\\.|[^"])*\"			{yylval.strval=strdup(yytext); return STRLITTOK;}
[a-zA-Z0-9# ]*         	{yylval.exrec.value=strdup(yytext);  return IDENTIFIER; }
.|\n                    { ECHO; }

%%

