codeunit 50100 TranslationManagement
{
    procedure LookupAddressInfo(Name: Text; var Customer: Record Customer)
    var
        Client: HttpClient;
        Content: HttpContent;
        ResponseMessage: HttpResponseMessage;
        Result: Text;
        JContent: JsonObject;
        JDetails: JsonObject;
        JLocations: JsonArray;
        JLocation: JsonObject;
        JPhones: JsonArray;
        JPhone: JsonObject;
    begin
        Content.WriteFrom('{domain":"' + Name + '"}');
        Client.DefaultRequestHeaders().Add('Authorization', 'Bearer <YOUR KEY>');
        Client.Post('https://api.fullcontact.com/v3/company.enrich', Content, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Error connecting to the Web Service.');
        ResponseMessage.Content().ReadAs(Result);
        //Result containt the ws response
        //Replace <YOUR KEY> with an API key from http://www.fullcontact.com 
        //Web Services result is a string in json format. 

        if not JContent.ReadFrom(Result) then
            Error('Invalid response from Web Service');
        JDetails := GetTokenAsObject(JContent, 'details', 'Invalid response from Web Service');
        JLocations := GetTokenAsArray(JDetails, 'locations', 'No locations available');
        JLocation := GetArrayElementAsObject(JLocations, 0, 'Location not available');
        JPhones := GetTokenAsArray(JDetails, 'phones', '');
        JPhone := GetArrayElementAsObject(JPhones, 0, '');
        Customer.Name := GetTokenAsText(JContent, 'name', '');
        Customer.Address := GetTokenAsText(JLocation, 'addressLine1', '');
        Customer.City := GetTokenAsText(JLocation, 'city', '');
        Customer."Post Code" := GetTokenAsText(JLocation, 'postalCode', '');
        Customer."Country/Region Code" := GetTokenAsText(JLocation, 'countryCode', '');
        Customer.County := GetTokenAsText(JLocation, 'country', '');
        Customer."Phone No." := GetTokenAsText(JPhone, 'value', '');
    end;


    procedure GetTokenAsText(JsonObject: JsonObject; TokenKey: Text; Error: Text): Text;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit('');
        end;
        exit(JsonToken.AsValue.AsText);
    end;

    procedure GetTokenAsObject(JsonObject: JsonObject; TokenKey: Text; Error: Text): JsonObject;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            if Error <> '' then
                Error(Error);
        exit(JsonToken.AsObject());
    end;

    procedure GetTokenAsArray(JsonObject: JsonObject; TokenKey: Text; Error: Text): JsonArray;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            if Error <> '' then
                Error(Error);
        exit(JsonToken.AsArray());
    end;

    procedure GetArrayElementAsObject(JsonArray: JsonArray; Index: Integer; Error: Text): JsonObject;
    var
        JsonToken: JsonToken;
    begin
        if not JsonArray.Get(Index, JsonToken) then
            if Error <> '' then
                Error(Error);
        exit(JsonToken.AsObject());
    end;



}