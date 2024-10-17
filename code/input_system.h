
extern char gAskQuestion;
extern char gInputBuffer[40];
extern char gInputBufferPos;
extern char gInputMaxSize;          // How many characters max are allowed

extern char gInputKey;
extern char gInputShift;

extern char gWordCount;          	        // How many tokens/word did we find in the input buffer
extern char gWordBuffer[MAX_WORDS];     	// One byte identifier of each of the identified words
//extern char gWordPosBuffer[MAX_WORDS];   	// Actual offset in the original input buffer, can be used to print the unrecognized words

typedef WORDS (*AnswerProcessingFun)();
extern AnswerProcessingFun gAnswerProcessingCallback;

extern WORDS AskInput(const char* inputMessage, char checkTockens);

extern void ResetInput();

// At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
extern unsigned char ParseInputBuffer();

