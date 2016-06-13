#include "ActiveBlocksStack.h"
#include <iostream>
using namespace std;

//Constructor initialize the stack.
// Assumes the Max number of blocks to be 10 in a program. So assigned maximum size of stack as 10
ActiveBlocksStack::ActiveBlocksStack()
{
  maxStack = 10;
  top = -1;
  items = new Actblock[maxStack];
}

//Checks if the stack is empty
bool ActiveBlocksStack::IsEmpty() const
{
  return (top == -1);
}

//Checks if the stack is full
bool ActiveBlocksStack::IsFull() const
{
  return (top == maxStack-1);
}

//Pushes the block number into the stack 
void ActiveBlocksStack::Push(Actblock blck) 
{
  if (IsFull())
  cout<<"Stack is full";
  top++;
  items[top] = blck;
}

//Removes a block number(top ) from the stack 
void ActiveBlocksStack::Pop()
{
  if( IsEmpty() )
  cout<<"Its empty";
  top--;
}

//Returns the block number which is on top of the stack 
Actblock ActiveBlocksStack::Top()
{
  if (IsEmpty())
  cout<<"Is Empty";
  return items[top];
}    

//Returns values from the stack 
int ActiveBlocksStack::get_stackvalue(int i)
{ 
 return  items[i];
}

