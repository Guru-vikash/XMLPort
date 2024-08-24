xmlport 50123 "Import G/L Data"
{
    Format = VariableText;
    Direction = Import;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '';
    // FormatEvaluate = Xml;
    // FieldSeparator = ';';
    schema
    {
        textelement(Root)
        {
            tableelement(GenJournalLine; "Gen. Journal Line")
            {
                textelement("Datewritten")
                {
                    trigger OnAfterAssignVariable()
                    begin
                        DateText := Datewritten;
                        // if DateText = '' then begin
                        //     SkipLine := true;
                        //     Error('%1 this date is missiong !', DateText);
                        // end
                        // else begin
                        GenJournalLine."Posting Date" := StringDateIntoDate(DateText);

                    end;

                    // FormattedDateText := STRSUBSTNO('%1/%2/%3', FORMAT(Month, 2), FORMAT(Day, 2), FORMAT(Year, 4));
                    // Evaluate(PostingDate, FormattedDateText);

                    // if Evaluate(GenJournalLine."Posting Date", Datewritten) then begin
                    //     GenJournalLine."Posting Date" := TempDate;
                    // end;

                }

                fieldelement(Acountnumber; GenJournalLine."Account No.")
                {

                }
                fieldelement(Description; GenJournalLine.Description)
                {

                }
                fieldelement(Debitamount; GenJournalLine."Debit Amount")
                {

                }
                fieldelement(Creditamount; GenJournalLine."Credit Amount")
                {

                }
                fieldelement(Axis1; GenJournalLine."Shortcut Dimension 1 Code")
                {

                }
                // textelement("Axis2")
                // {
                //     // SourceExpr = GenJournalLine."Shortcut Dimension 2 Code";
                // }
                trigger OnAfterGetRecord()
                begin

                end;

                trigger OnBeforeInsertRecord()
                var

                    DateTxt: Text;

                    Day: Integer;
                    Month: Integer;
                    Year: Integer;
                    GenBatch: Record "Gen. Journal Batch";
                    NoSeries: Codeunit "No. Series";
                    Counter: Integer;
                    GenLedset: Record "General Ledger Setup";
                    DimenValue: Record "Dimension Value";
                begin
                    Lineno += 10000;
                    GenJournalLine."Line No." := Lineno;
                    GenJournalLine."Journal Template Name" := GenJournalTemplate;
                    GenJournalLine."Journal Batch Name" := GenJournalBatch;
                    Counter += 1;

                    if GenBatch.Get(GenJournalTemplate, GenJournalBatch) then begin
                        if (GenJournalLine."Posting Date" = 0D) or (GenJournalLine."Account No." = '') or (GenJournalLine."Shortcut Dimension 1 Code" = '') then begin
                            if not DimenValue.Get(GenJournalLine."Shortcut Dimension 1 Code") then begin
                                ErrorRows += Format(Counter) + ',';
                                currXMLport.Skip();
                            end;
                        end
                        else begin
                            GenJournalLine."Document No." := NoSeries.GetNextNo(GenBatch."No. Series");
                        end;


                    end;
                end;
            }
        }
    }
    trigger OnPreXmlPort()
    begin
        Clear(recDialog);
        // DocNo := ;
        recDialog.Open('Record inserting: #1##########');



    end;


    var

        recDialog: Dialog;

        SkipLine: Boolean;
        GenJournalTemplate: Code[20];
        GenJournalBatch: Code[20];
        Lineno: Integer;
        DateText: Text;
        ErrorRows: Text;
        TempDate: Date;
        GLAccounts: Record "G/L Account";


    procedure setJournalTemp(Template: Code[20]; Batch: Code[20])
    begin
        GenJournalTemplate := Template;
        GenJournalBatch := Batch;
    end;

    local procedure StringDateIntoDate(DateText: Text): Date
    var

        Day: Integer;
        Month: Integer;
        Year: Integer;

        FormattedDateText: Text;
    begin
        if STRPOS(DateText, '.') > 0 then begin
            EVALUATE(Day, COPYSTR(DateText, 1, STRPOS(DateText, '.') - 1));
            DateText := DELSTR(DateText, 1, STRPOS(DateText, '.'));

            EVALUATE(Month, COPYSTR(DateText, 1, STRPOS(DateText, '.') - 1));
            DateText := DELSTR(DateText, 1, STRPOS(DateText, '.'));

            EVALUATE(Year, DateText);
            // GenJournalLine."Posting Date" := DMY2DATE(Day, Month, Year);
            TempDate := DMY2DATE(Day, Month, Year);
            exit(TempDate);
        end
        // else if STRPOS(DateText, '-') > 0 then begin
        //     EVALUATE(Day, COPYSTR(DateText, 1, STRPOS(DateText, '-') - 1));
        //     DateText := DELSTR(DateText, 1, STRPOS(DateText, '-'));

        //     EVALUATE(Month, COPYSTR(DateText, 1, STRPOS(DateText, '-') - 1));
        //     DateText := DELSTR(DateText, 1, STRPOS(DateText, '-'));

        //     EVALUATE(Year, DateText);
        //     // GenJournalLine."Posting Date" := DMY2DATE(Day, Month, Year);
        //     TempDate := DMY2DATE(Day, Month, Year);
        //     exit(TempDate);
        // end;
    end;

    local procedure CheckAccountExist(AccountNo: Code[20]): Boolean

    begin
        if GLAccounts.Get(AccountNo) then
            exit(false)
        else
            exit(true);
    end;



    trigger OnInitXmlPort()
    begin
        // Set the General Journal Template and Batch
        // GenJournalLine."Journal Template Name" := GenJournalTemplate.Name;
        // GenJournalLine."Journal Batch Name" := GenJournalBatch.Name;
        // FirstRow := true;

    end;

    trigger OnPostXmlPort()
    begin
        // Message('%1 No. of record import successfully', GenJournalLine.Count);
    end;
}