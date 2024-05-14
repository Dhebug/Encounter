
extern char gAskQuestion;
extern char gInputBuffer[40];
extern char gInputBufferPos;

extern char gWordCount;          	// How many tokens/word did we find in the input buffer
extern char gWordBuffer[10];     	// One byte identifier of each of the identified words
extern char gWordPosBuffer[10];   	// Actual offset in the original input buffer, can be used to print the unrecognized words

extern char gTextBuffer[80];    // Temp

typedef WORDS (*AnswerProcessingFun)();

extern WORDS AskInput(const char* inputMessage,AnswerProcessingFun callback, char checkTockens);

extern void ResetInput();

// At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
extern unsigned char ParseInputBuffer();

