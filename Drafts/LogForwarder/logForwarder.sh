# prepare the AWS environment
export AWS_ACCESS_KEY_ID="AKIASCXA4BATF2UD5BH6"
export AWS_SECRET_ACCESS_KEY="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"
# export AWS_SESSION_TOKEN="IQ......8Ua+Q=="
export AWS_DEFAULT_REGION=eu-central-1
export API_KEY="MyVeryLongDagobertPassword.#2023#1234567890"
export VPC_ID="vpc-0a4692e0205f91ae9"
export SUBNET_ID1="subnet-05c8a98ad9b70216d"                      # Must be routable / transition zone
export SUBNET_ID2="subnet-0b885b22ff7d3b191"                      # Must be routable / transition zone
export MANAGEMENT_ZONE="me-az-tech-dagobert"
export STAGE="preprod"
export STAK_NAME="dagobert-logforwarder-stack"
 
# initiate stack deployment
./dynatrace-aws-logs.sh deploy \
--target-url https://logs.e2e-mon.ec1.aws.aztec.cloud.allianz/$STAGE/$MANAGEMENT_ZONE \
--api-key $API_KEY \
--vpc-id $VPC_ID \
--subnet-id $SUBNET_ID1 \
--subnet-id $SUBNET_ID2 \
--check-connectivity false \
--stack-name $STACK_NAME

FIREHOSE_ARN=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='FirehoseArn'].OutputValue | [0]" --output text)
ROLE_ARN=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='CloudWatchLogsRoleArn'].OutputValue | [0]" --output text)

aws logs put-subscription-filter \
--log-group-name "$LOG_GROUP_NAME" \
--filter-name "dynatrace-log-forwarding" \
--filter-pattern "" \
--destination-arn "$FIREHOSE_ARN" \
--role-arn "$ROLE_ARN"