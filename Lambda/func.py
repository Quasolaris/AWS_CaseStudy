import json
def handler(event, context):
    #numerator = event.get('numerator')
    #denominator = event.get('denominator')
    #result = numerator/denominator
    result = "{\"Resultat\": \"einfuegen\"}"
    response = {
        "statusCode": 200,
        "statusDescription": "200 OK",
        "isBase64Encoded": False,
        "headers": {
            "Content-Type": "text/plain",
        },
        "body": json.dumps(result)
        }

    return response