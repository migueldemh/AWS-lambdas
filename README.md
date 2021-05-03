## Table of contents

- [Backgorund](#backgorund)
- [Preparation](#preparation)
- [Installation](#installation)
- [Clean](#clean)
- [Resources](#resources)

## Background and What is this.

Playing with different ways to build lambda funtions and ended with this.

The following code deploy a lambada funtion to monitor the connectivity of an URL. When the URL is no reachable via port 443 a Cloudwatch alarm is triggered.

- The installation is done by the makefile (I am using this for fun and learn about it, not recomneded).
- The provision is done by Cloudformation. The code is ship on S3.
- URL connectivity is checked by a lambda funtion. I use docker to build the package which contains the python app and the required additional packages. 
- Monitor logs/Alarms, Cloudwatch


## Preparation

- The environment where the code was tested has already a VPC and subnet.
- Set your AWS credentials.
- Modify the makefile:

```
vi makefile

#Modify the following lines:

STACK_NAME=<Name of the stack>-${UUID}
ResouceToMonitor=<Name of the resource>
EMAIL=<email>
URLNAME=https://<URL or IP>
```


## Installation

- Quick installation
```
make && make install
```

- Step by step

```
make && make package
```

Inside of the code folder you will find the libraries required and the lambda-monitor-url.py

```
.
├── code
│   ├── bin
│   ├── certifi
│   ├── certifi-2020.12.5.dist-info
│   ├── chardet
│   ├── chardet-4.0.0.dist-info
│   ├── idna
│   ├── idna-2.10.dist-info
│   ├── lambda-monitor-url.py
│   ├── requests
│   ├── requests-2.25.1.dist-info
│   ├── urllib3
│   └── urllib3-1.26.4.dist-info
├── lambda-monitor-url.py
├── lambdaCode_and_additionalPackages.zip
├── makefile
└── monitor-ui-lambda.json
```

lambdaCode_and_additionalPackages.zip should contain the compress code folder, then  

```
make install
```

## Clean

```
make clean
```

Remove the bucket created

## Resources

https://hands-on.cloud/how-to-create-and-deploy-your-first-python-aws-lambda-function/
https://www.nicolapietroluongo.com/python/how-to-build-an-aws-lambda-function-with-python-3-7-the-right-way/
