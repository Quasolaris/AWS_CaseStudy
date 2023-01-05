def handler(event, context):
    numerator = event.get('numerator')
    denominator = event.get('denominator')
    #result = numerator/denominator
    result = numerator
    response = {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {"Content-Type": "text/json; charset=utf-8"},
        "body": result
        }

    return response