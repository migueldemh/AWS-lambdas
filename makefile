SHELL=/bin/bash
.PHONY: init package clean

$(eval UUID=$(shell python -c 'import uuid; print(uuid.uuid4())'))
LAMBDA_ZIP=lambdaCode_and_additionalPackages.zip
STACK_NAME=<Name of the stack>-${UUID}
TempS3bucket=tmp-monitor-lambda-${UUID}
ResouceToMonitor=<Name of the resource>
EMAIL=<email>
URLNAME=https://<URL or IP>

init:	
	docker run --rm -v `pwd`:/src -w /src python /bin/bash -c "apt-get update && \
	mkdir -p ./code && \
	pip install requests -t ./code"

lambda.zip:
	cp lambda-monitor-url.py ./code 
	docker run --rm -v `pwd`:/src -w /src python /bin/bash -c "apt-get update && \
	apt-get install -y zip && \
	cd code; zip -r ../${LAMBDA_ZIP} ."

package: lambda.zip

install: lambda.zip
	aws s3 mb s3://${TempS3bucket}
	aws s3 cp ${LAMBDA_ZIP} s3://${TempS3bucket}/lambdas/${LAMBDA_ZIP}
	$(eval VPCIP=$(shell aws ec2 --no-verify-ssl describe-vpcs --filters Name=tag:Name,Values="*central*" --query "Vpcs[].VpcId" --output text))
	$(eval SUBNETID=$(shell aws ec2 --no-verify-ssl describe-subnets  --filters Name=tag:Name,Values="*central.*.private_subnets.0*" --query "Subnets[].SubnetId" --output text))
	aws cloudformation create-stack \
	--template-body file://monitor-ui-lambda.json \
	--stack-name ${STACK_NAME} \
	--disable-rollback \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameters ParameterKey=URLname,ParameterValue=${URLNAME} \
	ParameterKey=Email,ParameterValue=${EMAIL} \
	ParameterKey=VpcId,ParameterValue=${VPCIP} \
	ParameterKey=ResouceToMonitor,ParameterValue=${ResouceToMonitor} \
	ParameterKey=SubnetId,ParameterValue=${SUBNETID} \
	ParameterKey=S3Bucket,ParameterValue=${TempS3bucket} \
	ParameterKey=S3Key,ParameterValue=${LAMBDA_ZIP} 

clean:
	rm -rf ./code;
	rm -rf ./$(LAMBDA_ZIP);
