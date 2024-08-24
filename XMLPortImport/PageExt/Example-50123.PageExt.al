// pageextension 61008 CFAU_SalesQuoteSubformExt extends "Sales Quote Subform"
// {
//     layout
//     {
//         addlast(Control35)
//         {
//             field(AdjProfitLCY; AdjProfitLCY[2]) // 2 is invoicing
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Adjusted Profit (LCY)';
//                 Editable = false;
//             }
//             field(AdjProfitPct; AdjProfitPct[2])
//             {
//                 ApplicationArea = Basic, Suite;
//                 Caption = 'Adjusted Profit %';
//                 Editable = false;
//             }
//         }
//     }
//     trigger OnAfterGetCurrRecord()
//     begin
//         RefreshOnAfterGetRecord();
//     end;

//     var
//         SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
//         AdjProfitLCY: array[3] of Decimal;
//         AdjProfitPct: array[3] of Decimal;
//         TotalSalesLine: array[3] of Record "Sales Line";
//         TotalSalesLineLCY: array[3] of Record "Sales Line";
//         SalesPost: Codeunit "Sales-Post";
//         VATAmount: array[3] of Decimal;
//         ProfitLCY: array[3] of Decimal;
//         ProfitPct: array[3] of Decimal;
//         TempVATAmountLine1: Record "VAT Amount Line" temporary;
//         TempVATAmountLine2: Record "VAT Amount Line" temporary;
//         TempVATAmountLine3: Record "VAT Amount Line" temporary;
//         PrepmtTotalAmount: Decimal;
//         PrepmtVATAmount: Decimal;
//         TotalAdjCostLCY: array[3] of Decimal;
//         VATAmountText: array[3] of Text[30];
//         i: Integer;

//     local procedure RefreshOnAfterGetRecord()
//     var
//         SalesHeader: Record "Sales Header";
//         TempSalesLine: Record "Sales Line" temporary;
//         SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
//         OptionValueOutOfRange: Integer;
//     begin
//         TempSalesLine.DeleteAll();
//         Clear(TempSalesLine);
//         Clear(TotalSalesLine);
//         Clear(TempVATAmountLine1);
//         Clear(TempVATAmountLine2);
//         Clear(TempVATAmountLine3);
//         Clear(TotalSalesLineLCY);
//         Clear(VATAmount);
//         Clear(ProfitLCY);
//         Clear(ProfitPct);
//         Clear(AdjProfitLCY);
//         Clear(AdjProfitPct);
//         Clear(TotalAdjCostLCY);
//         Clear(VATAmountText);
//         SalesHeader.Reset();
//         SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
//         SalesHeader.SetRange("No.", Rec."Document No.");
//         if SalesHeader.FindFirst() then;
//         for i := 1 to 3 do begin
//             TempSalesLine.DeleteAll();
//             Clear(TempSalesLine);
//             Clear(SalesPost);
//             SalesPost.GetSalesLines(SalesHeader, TempSalesLine, i - 1, false);
//             Clear(SalesPost);
//             case i of
//                 1:
//                     Rec.CalcVATAmountLines(0, SalesHeader, TempSalesLine, TempVATAmountLine1);
//                 2:
//                     Rec.CalcVATAmountLines(0, SalesHeader, TempSalesLine, TempVATAmountLine2);
//                 3:
//                     Rec.CalcVATAmountLines(0, SalesHeader, TempSalesLine, TempVATAmountLine3);
//             end;
//             //2 is of type invoicing in statistics calculation
//             SalesPost.SumSalesLinesTemp(SalesHeader, TempSalesLine, i - 1, TotalSalesLine[i], TotalSalesLineLCY[i], VATAmount[i], VATAmountText[i], ProfitLCY[i], ProfitPct[i], TotalAdjCostLCY[i], false);
//             AdjProfitLCY[i] := TotalSalesLineLCY[i].Amount - TotalAdjCostLCY[i];
//             if TotalSalesLineLCY[i].Amount <> 0 then AdjProfitPct[i] := Round(AdjProfitLCY[i] / TotalSalesLineLCY[i].Amount * 100, 0.1);
//         end;
//     end;
// }