codeunit 50101 EmailValidation_PKT
{
    [EventSubscriber(ObjectType::table, Database::Customer, 'OnAfterValidateEvent', 'E-Mail', false, false)]
    local procedure ValidateCustomerEmail(var Rec: Record Customer)
    var
        httpClient: HttpClient;
        httpResponse: HttpResponseMessage;
        jsonText: Text;
        jsonObj: JsonObject;
        funcUrl: Label 'https://yourfunctionurl/api/emailvalidatorcore?email=';
        InvalidEmailError: Label 'Invalid email address.';
        InvalidJonError: Label 'Invalid JSON response.';
        validationResult: Boolean;
    begin
        if rec."E-Mail" <> '' then begin
            EnableExternalCallsInSandbox();
            httpClient.Get(funcUrl + rec."E-Mail", httpResponse);
            httpResponse.Content().ReadAs(jsonText);
            //Response JSON format: {"Email":"test@packt.com","Valid":true}
            if not jsonObj.ReadFrom(jsonText) then
                Error(InvalidJonError);
            //Read the Valid token from the response
            validationResult := GetJsonToken(jsonObj, 'Valid').AsValue().AsBoolean();
            if not validationResult then
                Error(InvalidEmailError);
        end;
    end;

    local procedure GetJsonToken(jsonObject: JsonObject; token: Text) jsonToken: JsonToken
    var
        TokenNotFoundErr: Label 'Token %1 not found.';
    begin
        if not jsonObject.Get(token, jsonToken) then
            Error(TokenNotFoundErr, token);
    end;

    local procedure EnableExternalCallsInSandbox()
    var
        NAVAppSetting: Record "NAV App Setting";
        TenantManagement: Codeunit "Tenant Management";
        ModInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        if TenantManagement.IsSandbox() then begin
            NAVAppSetting."App ID" := ModInfo.Id();
            NAVAppSetting."Allow HttpClient Requests" := true;
            if not NAVAppSetting.Insert() then
                NAVAppSetting.Modify();
        end;
    end;

}