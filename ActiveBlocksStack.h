//******************************
//  ActiveBlock Stack Class Header
//ActiveBlocksStack.h
//******************************
#ifndef ActiveBlocksStack_h					// avoid repeated expansion
#define ActiveBlocksStack_h

typedef int Actblock;

class ActiveBlocksStack
{
public:
		ActiveBlocksStack();              //Constructor
		void Push(Actblock blck);     //Pushes block number into stack
		void Pop();                     //Pops block number from stack
		Actblock Top();	 //Returns block number which is on top of stack
		bool IsEmpty() const;            //Checks if stack is empty
		bool IsFull() const;                 //Checks if stack is full
		int get_stackvalue(int i);       //Gets the value in the stack
private:
		int maxStack;
		int top;
		Actblock* items;    
};
#endif
