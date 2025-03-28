This tool was discovered and chosen to enter the 2025 TensorReady AI Agentic Innovation Competition! Was entered into the competition in March. 

This tool works with OpenAI's application programming interface and was built as a tool to be used personally for sending prompts to and from OpenAI's large language models. There are two executables. "discuss.sh" uses the voice recognition to transcribe a collected audio file into a text file. This transcribed file is then sent to OpenAI. A response is returned in the form of a json response, which is then converted into a readable text file called "output". 

The second executable for sending written prompts to OpenAI. This allows for sending a typed out prompt to OpenAI. It is faster and more efficient because it does not have the overhead of voice transcription and converting a heavy .wav file into a .txt file. I wanted to have them both at my expense when developing.

Both require a user to acquire an OpenAI API key which can be received from OpenAI's API website. This will need to be stored locally on the system of the user by adding it to the shell's environment variable file. 

During use, a number of files will start to populate current working directory. The second executable "introduce.sh" requires a file to be passed with it as an argument. To do this, once navigated to the tools directory use "touch write.txt". This way a new file will be used. You will want to add your prompt to this file as it will serve as the written prompt to OpenAI's API. A "prompt.wav", "prompt.txt", "output.txt", "response.json" will populate the directory during and after use of the tool. These files do not need to be maintained manually as they will be truncated and overwritten when the tool gets used again.
