#./dynatrace-aws-logs.sh deploy \
#--target-url https://logs.e2e-mon.ec1.aws.aztec.cloud.allianz/<STAGE>/<MANAGEMENT_ZONE> \
#--api-key <API_KEY> \
#--vpc-id <AWS_VPC_ID> \
#--subnet-id <AWS_SUBNET_ID_1> \
#--subnet-id <AWS_SUBNET_ID_2> \
#--check-connectivity false \
#--stack-name <STACK_NAME> 
#--permissions-boundary-arn arn:aws:iam::143279261734:policy/aztec-cloudtribe-allianzboundary-policy

./dynatrace-aws-logs.sh deploy \
--target-url https://logs.e2e-mon.ec1.aws.aztec.cloud.allianz/preprod/mz-az-tech-dagobert \
--api-key "MyVeryLongDagobertPassword.#2023#1234567890" \
--vpc-id vpc-0a4692e0205f91ae9 \
--subnet-id subnet-030e81d313077d163 \
--subnet-id subnet-01747ba9f399774ec \
--check-connectivity false \
--stack-name dagobert-logforwarder-stack \
--permissions-boundary-arn arn:aws:iam::143279261734:policy/aztec-cloudtribe-allianzboundary-policy

# prepare the AWS environment
export AWS_ACCESS_KEY_ID="ASIASCXA4BATLAJVXVUF"
export AWS_SECRET_ACCESS_KEY="sbrrmasP9Yf8dETqvkQML+dvLxgZ9nZGzYYBERX2"
export VPC_ID="vpc-0a4692e0205f91ae9"
export SUBNET_ID1="subnet-030e81d313077d163"
export SUBNET_ID2="subnet-01747ba9f399774ec"

export AWS_ACCESS_KEY_ID="AKIASCXA4BATF2UD5BH6"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION=eu-central-1
export API_KEY="MyVeryLongDagobertPassword.#2023#1234567890"
export VPC_ID="vpc-0a4692e0205f91ae9"
export SUBNET_ID1="subnet-057f0e263d39c247d"
export SUBNET_ID2="subnet-05823df7eab7c577f"
export MANAGEMENT_ZONE="mz-az-tech-dagobert"
export STAGE="preprod"
 
# initiate stack deployment
./dynatrace-aws-logs.sh deploy \
--target-url https://logs.e2e-mon.ec1.aws.aztec.cloud.allianz/$STAGE/$MANAGEMENT_ZONE \
--api-key $API_KEY \
--vpc-id $VPC_ID \
--subnet-id $SUBNET_ID1 \
--subnet-id $SUBNET_ID2 \
--check-connectivity false \
--stack-name dagobert-logforwarder-stack

Updated Lambda code of arn:aws:lambda:eu-central-1:143279261734:function:dagobert-logforwarder-stack-Lambda-EQtHwyrXrKjm

[
    {
        "OutputKey": "FirehoseArn",
        "OutputValue": "arn:aws:firehose:eu-central-1:143279261734:deliverystream/dagobert-logforwarder-stack-FirehoseLogStreams-qd2A54owGFQF",
        "Description": "Firehose ARN",
        "ExportName": "dagobert-logforwarder-stack:FirehoseARN"
    },
    {
        "OutputKey": "LambdaArn",
        "OutputValue": "arn:aws:lambda:eu-central-1:143279261734:function:dagobert-logforwarder-stack-Lambda-EQtHwyrXrKjm",
        "Description": "Lambda ARN"
    },
    {
        "OutputKey": "CloudWatchLogsRoleArn",
        "OutputValue": "arn:aws:iam::143279261734:role/dagobert-logforwarder-stack-CloudWatchLogsRole-1XE1U3FZH6YVX",
        "Description": "CloudWatch Logs role ARN allowing streaming to Firehose",
        "ExportName": "dagobert-logforwarder-stack:CloudWatchARN"
    }
]

# in CloudShell starten:
aws logs put-subscription-filter \
--log-group-name "/aws/rds/cluster/azd-service-dbs-aws-aurora-resize1-dev/postgresql" \
--filter-name "dynatrace-log-forwarding" \
--filter-pattern "" \
--destination-arn "arn:aws:firehose:eu-central-1:143279261734:deliverystream/dagobert-logforwarder-stack-FirehoseLogStreams-qd2A54owGFQF" \
--role-arn "arn:aws:iam::143279261734:role/dagobert-logforwarder-stack-CloudWatchLogsRole-1XE1U3FZH6YVX"

FIREHOSE_ARN=$(aws cloudformation describe-stacks --stack-name "dagobert-logforwarder-stack" --query "Stacks[0].Outputs[?OutputKey=='FirehoseArn'].OutputValue | [0]" --output text)
ROLE_ARN=$(aws cloudformation describe-stacks --stack-name "dagobert-logforwarder-stack" --query "Stacks[0].Outputs[?OutputKey=='CloudWatchLogsRoleArn'].OutputValue | [0]" --output text)

while [ true ]; do curl -vv -k --request POST 'https://logs.e2e-mon.ec1.aws.aztec.cloud.allianz/preprod/mz-az-tech-dagobert' --header 'Authorization: Api-Token MyVeryLongDagobertPassword.#2023#1234567890' --header 'Content-Type: application/json' --data-raw '[{ "content": "This is my favorite log line!"}]';done;