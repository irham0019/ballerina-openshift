import ballerina/http;
import ballerina/log;
import ballerina/kubernetes;
import ballerina/openshift;
@kubernetes:Service {}
@openshift:Route {
    host: "ballerina-test"
}
listener http:Listener helloEP = new(9090);
@kubernetes:Deployment {
    namespace: "wso2",
    registry: "172.30.1.1:5000",
    image: "hello-service:v1.0",
    buildImage: true,
    buildExtension: openshift:BUILD_EXTENSION_OPENSHIFT
}
@http:ServiceConfig {
    basePath: "/hello"
}
service hello on helloEP {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{user}"
    }
    resource function sayHello(http:Caller caller, http:Request request, string user) {
        string userName = string `${<@untainted string> user}!`;
        json j9 = { name: userName, age: 20, marks: { math: 90, language: 95 } };
        var responseResult = caller->respond(j9);
        if (responseResult is error) {
            error err = responseResult;
            log:printError("Error sending response", err);
        }
    }
}