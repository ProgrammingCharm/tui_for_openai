#!/bin/bash

# Variables
INPUT_FILE="$1"
RESPONSE_FILE="response.json"
FINAL_OUTPUT="output.txt"

# Read content from file
PROMPT=$(jq -Rs . "$INPUT_FILE")

#Verify content of prompt
# echo "Prompt: $PROMPT"

# Send to OpenAI API
echo "Sending prompt to OpenAI API..."
JSON_PAYLOAD=$(jq -n \
	--arg model "gpt-4o-mini" \
	--argjson messages "[{\"role\": \"user\", \"content\": $PROMPT}]" \
	'{model: $model, messages: $messages}')

#Verify JSON Payload gets formatted correctly
# echo "JSON Payload: $JSON_PAYLOAD"

# Curl request to OpenAI API
HTTP_STATUS=$(curl -s -w "%{http_code}" -o $RESPONSE_FILE https://api.openai.com/v1/chat/completions \
	-H "Authorization: Bearer $OPENAI_API_KEY" \
	-H "Content-Type: application/json" \
	-d "$JSON_PAYLOAD")

# Print response status code
# echo "HTTP Status Code: $HTTP_STATUS"

# Extract "content" field from JSON response save to final output which is output.txt

if [ -s $RESPONSE_FILE ]; then
	if jq -e . >/dev/null 2>&1 <$RESPONSE_FILE; then
		cat $RESPONSE_FILE | jq -r '.choices[0].message.content' > $FINAL_OUTPUT
	else
		echo "Invalid JSON response:"
		cat $RESPONSE_FILE
	fi
else
	echo "Response file is empty or contains an error."
fi



echo "Process complete and saved to $FINAL_OUTPUT."


