
extern char gAskQuestion;
extern char gInputBuffer[40];
extern char gInputBufferPos;
extern char gInputMaxSize;          // How many characters max are allowed
extern char gInputAcceptsEmpty;     // Do we accept nothing as a valid answer?

extern char gInputKey;
extern char gInputShift;
extern char gInputErrorCounter;
extern char gInputDone;

extern char gWordCount;          	        // How many tokens/word did we find in the input buffer
extern char gWordBuffer[MAX_WORDS];     	// One byte identifier of each of the identified words
//extern char gWordPosBuffer[MAX_WORDS];   	// Actual offset in the original input buffer, can be used to print the unrecognized words

typedef WORDS (*AnswerProcessingFun)();
extern AnswerProcessingFun gAnswerProcessingCallback;
extern const char* gInputMessage;

extern void AskInput();

extern void ResetInput();

