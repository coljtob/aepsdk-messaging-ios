#!/bin/bash

djq() {
    docker run --rm -i -w /tmp -v "$SCRIPT_DIR":/tmp docker-hub-remote.dr.corp.adobe.com/stedolan/jq:latest "$@"
}

dcurl() {
  docker run --rm  -i -w /tmp -v "$SCRIPT_DIR":/tmp docker-hub-remote.dr.corp.adobe.com/ibmcom/curl:4.2.0-build.2 "$@"
}

base64url_encode() {
    # Standard Base64 encoding
    encoded_data=$(echo "$1" | base64)

    # Convert to Base64URL encoding
    base64url_encoded=$(echo "$encoded_data" | tr '+/' '-_' | tr -d '=')

    # Ensure at least one '=' at the end for proper decoding
    if [ ${#encoded_data} -gt 1 ] && [ "${encoded_data: -1}" = "=" ]; then
        base64url_encoded="${base64url_encoded}="
    fi

    echo "$base64url_encoded"
}

# Concatenate username and password with a delimiter (you can use any delimiter you prefer)
data_to_encode="coljtob:${SAUCE_KEY}"

# Encode the data using Base64URL
auth=$(base64url_encode "$data_to_encode")

final_auth="Authorization: Basic ${auth}"

IOS_GROUP_ID=$(dcurl -s -X GET 'https://api.us-west-1.saucelabs.com/v1/storage/files?name=MessagingDemoApp.ipa' -H "$final_auth" | djq -r .items[0].group_id)

echo "Processing group_id: $IOS_GROUP_ID"
url="https://api.us-west-1.saucelabs.com/v1/storage/groups/$IOS_GROUP_ID"
DELETE_IOS_RESPONSE=$(dcurl -s -X DELETE "$url" \
-H "$final_auth")
echo "delete response is $DELETE_IOS_RESPONSE"  

# ANDROID_GROUP_ID=$(dcurl -s -X GET 'https://api.us-west-1.saucelabs.com/v1/storage/files?name=assurance-testapp-debug.apk' -H "$final_auth" | djq -r .items[0].group_id)

# echo "Processing group_id: $ANDROID_GROUP_ID"
# url="https://api.us-west-1.saucelabs.com/v1/storage/groups/$ANDROID_GROUP_ID"
# DELETE_ANDROID_RESPONSE=$(dcurl -s -X DELETE "$url" \
# -H "$final_auth")
# echo "delete response is $DELETE_ANDROID_RESPONSE"  