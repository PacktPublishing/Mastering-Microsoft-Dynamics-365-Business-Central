pageextension 50103 ItemListExt extends "Item List"
{

    actions
    {
        addlast(Creation)
        {
            Action(Upload)
            {
                ApplicationArea = All;
                Caption = 'Upload file to Azure Blob Storage';
                Image = Add;
                Promoted = true;

                trigger OnAction();
                var
                    SaaSFileMgt: Codeunit SaaSFileMgt;
                begin
                    SaaSFileMgt.UploadFile();
                end;
            }

            Action(Download)
            {
                ApplicationArea = All;
                Caption = 'Download file from Azure Blob Storage';
                Image = MoveDown;
                Promoted = true;

                trigger OnAction();
                var
                    SaaSFileMgt: Codeunit SaaSFileMgt;
                begin
                    SaaSFileMgt.DownloadFile('TEST.txt', 'https://d365bcfilestorage.blob.core.windows.net/d365bcfiles/TEST.txt');
                end;
            }
        }
    }


}