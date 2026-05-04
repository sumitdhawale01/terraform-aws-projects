import json
import boto3
import os

sqs = boto3.client('sqs')

def lambda_handler(event, context):
    body = json.loads(event['body'])

    if not body.get('name') or not body.get('message'):
        return {
            'statusCode': 400,
            'body': json.dumps("Invalid input")
        }

    sqs.send_message(
        QueueUrl=os.environ['QUEUE_URL'],
        MessageBody=json.dumps(body)
    )

    return {
        'statusCode': 200,
        'body': json.dumps("Feedback accepted")
    }