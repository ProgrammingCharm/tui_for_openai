#!/bin/bash
AUDIO_FILE="prompt.wav"
OUTPUT_FILE="prompt.txt"
RESPONSE_FILE="response.json"
FINAL_OUTPUT="output.txt"

#Record Audio
echo "Recording audio as $AUDIO_FILE... Press Ctrl+C to stop."
arecord -f cd -t wav -d 0 -q "$AUDIO_FILE"

#Transcribe audio
whisper "$AUDIO_FILE" --model tiny --output_format txt --output_dir . > /dev/null 2>&1
echo "Transcription complete and saved to $OUTPUT_FILE."

# Send to OpenAI API
PROMPT=$(jq -Rs . "$OUTPUT_FILE")

# Verify content of prompt for debugging purposes
#echo "Prompt: $PROMPT"

echo "Sending prompt to OpenAI API..."
JSON_PAYLOAD=$(jq -n \
	--arg model "gpt-4o-mini" \
	--argjson messages "[{\"role\": \"user\", \"content\": $PROMPT}]" \
	'{model: $model, messages: $messages}')

# Verify JSON Payload gets formatted correctly for debugging purposes
#echo "JSON Payload: $JSON_PAYLOAD"
	
# curl request to OpenAI API
HTTP_STATUS=$(curl -s -w "%{http_code}" -o $RESPONSE_FILE https://api.openai.com/v1/chat/completions \
	-H "Authorization: Bearer $OPENAI_API_KEY" \
	-H "Content-Type: application/json" \
	-d "$JSON_PAYLOAD") 

# Print response status code for debugging purposes
#echo "HTTP Status Code: $HTTP_STATUS"

# Extract "content" field from json response and save it to FINAL_OUTPUT which is output.txt
if [ -s $RESPONSE_FILE ]; then
	if jq -e . >/dev/null 2>&1 < $RESPONSE_FILE; then
		cat $RESPONSE_FILE | jq -r '.choices[0].message.content' > $FINAL_OUTPUT
	else
		echo "Invalid JSON response:"
		cat $RESPONSE_FILE
	fi 
else
	echo "Response file is empty or contains an error."
fi



echo "Process complete and saved to $FINAL_OUTPUT."


