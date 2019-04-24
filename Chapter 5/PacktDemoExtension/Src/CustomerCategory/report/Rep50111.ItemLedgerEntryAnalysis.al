report 50111 "Item Ledger Entry Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report50111.ItemLedgerEntryAnalysis.rdl';
    WordLayout = './Report50111.ItemLedgerEntryAnalysis.docx';
    EnableExternalImages = true;

    Caption = 'Item Ledger Entry Analysis';
    UsageCategory=ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry";"Item Ledger Entry")
        {
            column(ItemNo_ItemLedgerEntry;"Item Ledger Entry"."Item No.")
            {
                IncludeCaption = true;
            }
            column(PostingDate_ItemLedgerEntry;"Item Ledger Entry"."Posting Date")
            {
                IncludeCaption = true;
            }
            column(EntryType_ItemLedgerEntry;"Item Ledger Entry"."Entry Type")
            {
                IncludeCaption = true;
            }
            column(SourceNo_ItemLedgerEntry;"Item Ledger Entry"."Source No.")
            {
                IncludeCaption = true;
            }
            column(DocumentNo_ItemLedgerEntry;"Item Ledger Entry"."Document No.")
            {
                IncludeCaption = true;
            }
            column(Description_ItemLedgerEntry;"Item Ledger Entry".Description)
            {
                IncludeCaption = true;
            }
            column(LocationCode_ItemLedgerEntry;"Item Ledger Entry"."Location Code")
            {
                IncludeCaption = true;
            }
            column(Quantity_ItemLedgerEntry;"Item Ledger Entry".Quantity)
            {
                IncludeCaption = true;
            }
            column(COMPANYNAME;CompanyName)
            {
            }
            column(includeLogo;includeLogo)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(includeLogo;includeLogo)
                    {
                        Caption = 'Include company logo';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PageNo = 'Page'; //ITA=Pagina
        BCReportName ='Item Ledger Entry Analysis'; //ITA=Analisi Movimenti Articolo
    }

    trigger OnPreReport()
    begin
        if includeLogo then begin
          CompanyInfo.Get;  //Get Company Information record
          CompanyInfo.CalcFields(Picture);  //Retrieve company logo
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        includeLogo: Boolean;

}
