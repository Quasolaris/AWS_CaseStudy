package ch.fhnw.pcls;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.HashMap;
import java.util.List;

// Handler value: example.HandlerDivide
public class Handler implements RequestHandler<List<Integer>, APIGatewayProxyResponseEvent>{
  Gson gson = new GsonBuilder().setPrettyPrinting().create();

  @Override
  public APIGatewayProxyResponseEvent handleRequest(List<Integer> event, Context context)
  {
    LambdaLogger logger = context.getLogger();
    APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
    response.setIsBase64Encoded(false);
    response.setStatusCode(200);
    HashMap<String, String> headers = new HashMap<String, String>();
    headers.put("Content-Type", "text/html");
    headers.put("Access-Control-Allow-Headers", "Content-Type");
    headers.put("Access-Control-Allow-Origin", "*");
    headers.put("Access-Control-Allow-Methods", "OPTIONS,POST,GET");
    response.setHeaders(headers);
    logger.log("EVENT: " + gson.toJson(event));
    logger.log("EVENT TYPE: " + event.getClass().toString());
    response.setBody("HelloWorld");
    
    return response;
  }
}