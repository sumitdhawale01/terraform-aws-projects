# import json
# import boto3
# import os
# from datetime import datetime

# dynamodb = boto3.resource('dynamodb')
# sns = boto3.client('sns')

# table = dynamodb.Table(os.environ['TABLE_NAME'])

# def lambda_handler(event, context):
#     for record in event['Records']:
#         body = json.loads(record['body'])

#         if "bad" in body['message'].lower():
#             sentiment = "negative"
#         else:
#             sentiment = "positive"

#         body['sentiment'] = sentiment
#         body['timestamp'] = datetime.utcnow().isoformat()

#         table.put_item(Item=body)

#         sns.publish(
#             TopicArn=os.environ['TOPIC_ARN'],
#             Message=f"Processed: {body}"
#         )

import json
import boto3
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    for record in event['Records']:
        try:
            body = json.loads(record['body'])
            print("Parsed body:", body)

            # Sentiment logic
            if "bad" in body['message'].lower():
                sentiment = "negative"
            else:
                sentiment = "positive"

            body['sentiment'] = sentiment
            body['timestamp'] = datetime.utcnow().isoformat()

            # Store in DynamoDB
            table.put_item(Item=body)
            print("Stored in DynamoDB")

            # Send SNS notification
            sns.publish(
                TopicArn=os.environ['TOPIC_ARN'],
                Subject="New Feedback Processed",   # 🔥 important for email
                Message=json.dumps({
                    "feedback_id": body['feedback_id'],
                    "name": body['name'],
                    "message": body['message'],
                    "sentiment": body['sentiment'],
                    "timestamp": body['timestamp']
                }, indent=2)
            )

            print("SNS notification sent")

        except Exception as e:
            print("Error processing record:", str(e))
            raise e  # ensures retry via SQS