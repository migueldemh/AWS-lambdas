import os
import requests

def check(url, response_timeout):
    result = requests.get(url,timeout=response_timeout,verify=False)
    return str(result.status_code)

def lambda_handler(event, context):
    url = os.environ['url']
    response_code = os.environ['response_code']
    response_timeout = os.environ['response_timeout']
    if check(url, int(response_timeout)) != response_code:
        raise Exception("{url} is down".format(url=url))
