codeunit 50103 SaaSFileMgt
{
    procedure UploadFile()
    var
        fileMgt: Codeunit "File Management";
        selectedFile: Text;
        //tempblob: Codeunit "Temp Blob";
        httpClient: HttpClient;
        httpContent: HttpContent;
        jsonBody: text;
        httpResponse: HttpResponseMessage;
        httpHeader: HttpHeaders;
        fileName: Text;
        fileExt: Text;
        //v15
        base64Convert: Codeunit "Base64 Convert";
        instr: InStream;
    begin
        //selectedFile := fileMgt.OpenFileDialog('Select file to upload', '', '');        
        //tempblob.Import(selectedFile);

        //v15
        UploadIntoStream('Select a file to upload', '', '', selectedFile, instr);
        fileName := delchr(fileMgt.GetFileName(selectedFile), '=', '.' + fileMgt.GetExtension(selectedFile));
        fileExt := fileMgt.GetExtension(selectedFile);
        jsonBody := ' {"base64":"' + base64Convert.ToBase64(instr) +
        '","fileName":"' + fileName + '.' + fileExt +
        '","fileType":"' + GetMimeType(selectedFile) + '", "fileExt":"' + fileMgt.GetExtension(selectedFile) + '"}';

        httpContent.WriteFrom(jsonBody);
        httpContent.GetHeaders(httpHeader);
        httpHeader.Remove('Content-Type');
        httpHeader.Add('Content-Type', 'application/json');
        httpClient.Post(BaseUrlUploadFunction, httpContent, httpResponse);
        //Here we should read the response to retrieve the URI
        message('File uploaded.');
    end;

    procedure DownloadFile(fileName: Text; blobUrl: Text)
    var
        tempblob: Codeunit "Temp Blob";
        httpClient: HttpClient;
        httpContent: HttpContent;
        jsonBody: text;
        httpResponse: HttpResponseMessage;
        httpHeader: HttpHeaders;
        base64: Text;
        fileType: Text;
        fileStream: InStream;
        //v15
        base64Convert: Codeunit "Base64 Convert";
        outstr: OutStream;
    begin
        fileType := GetMimeType(fileName);
        jsonBody := ' {"url":"' + blobUrl + '","fileName":"' + fileName + '", "fileType":"' + fileType + '"}';
        httpContent.WriteFrom(jsonBody);
        httpContent.GetHeaders(httpHeader);
        httpHeader.Remove('Content-Type');
        httpHeader.Add('Content-Type', 'application/json');
        httpClient.Post(BaseUrlDownloadFunction, httpContent, httpResponse);
        httpResponse.Content.ReadAs(base64);
        base64 := DelChr(base64, '=', '"');
        //v15
        //tempblob.FromBase64String(base64);
        base64Convert.FromBase64(base64);
        tempblob.CreateOutStream(outstr);
        outstr.WriteText(base64);
        //end v15
        tempblob.CreateInStream(fileStream);
        DownloadFromStream(fileStream, 'Download file from Azure Storage', '', '', fileName);
    end;

    local procedure GetMimeType(selectedFile: Text): Text
    var
        fileMgt: Codeunit "File Management";
        mimeType: Text;
    begin
        case lowercase(fileMgt.GetExtension(selectedFile)) of
            'pdf':
                mimeType := 'application/pdf';
            'txt', 'csv':
                mimeType := 'text/plain';
            'png':
                mimeType := 'image/png';
            'jpg':
                mimeType := 'image/jpg';
            'bmp':
                mimeType := 'image/bmp';
            else
                Error('File Format not supported!');
        end;
        EXIT(mimeType);
    end;

    var
        BaseUrlUploadFunction: Label 'https://saasfilemgt.azurewebsites.net/api/UploadFile?code=YOURFUNCTIONKEY';
        BaseUrlDownloadFunction: Label 'https://saasfilemgt.azurewebsites.net/api/DownloadFile?code=YOURFUNCTIONKEY';
}

