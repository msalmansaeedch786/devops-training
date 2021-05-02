import json
from botocore.exceptions import ClientError
import boto3

def lambda_handler(event, context):

    Message=json.loads(event['Records'][0]['Sns']['Message'])
    InstacneID=[msg['value'] for msg in Message['Trigger']['Dimensions'] if msg['name']=='InstanceId'][0]
    
    SENDER = "rizwan.sharif@northbaysolutions.net"
    RECIPIENT = "rizwan.sharif@northbaysolutions.net"
    AWS_REGION = "us-east-1"
    SUBJECT = "Alarm | EC2 | Memory Utilization is more than 70%"
    BODY_TEXT = "EC2 InstacneID: " + InstacneID
    CHARSET = "UTF-8"
    
    # Create a new SES resource and specify a region.
    client = boto3.client('ses',region_name=AWS_REGION)
    
    # Try to send the email.
    try:
        response = client.send_email(
            Destination={
                'ToAddresses': [
                    RECIPIENT,
                ],
            },
            Message={
                'Body': {
                    'Text': {
                        'Charset': CHARSET,
                        'Data': BODY_TEXT,
                    },
                },
                'Subject': {
                    'Charset': CHARSET,
                    'Data': SUBJECT,
                },
            },
            Source=SENDER
        )
    # Display an error if something goes wrong. 
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID:"),
        print(response['MessageId'])
