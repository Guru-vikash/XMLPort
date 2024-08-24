pageextension 50112 "General Journal Extend " extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst("A&ccount")
        {
            action("Import G/L Account")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var

                    GenJournal: Record "Gen. Journal Line";
                    xmlport: XmlPort "Import G/L Data";
                    Instream: InStream;
                    Outstream: OutStream;
                begin
                    // if (GenJournalTemp.Get(Rec."Journal Template Name")) and (GenJournalTemp.Get(Rec."Journal Batch Name")) then begin
                    File.UploadIntoStream('', Instream);
                    // Outstream.Write(Instream);
                    // Xmlport.Run(50123, false, true);
                    xmlport.setJournalTemp(Rec."Journal Template Name", Rec."Journal Batch Name");
                    xmlport.SetSource(Instream);
                    xmlport.Import();
                    // end;

                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;



}