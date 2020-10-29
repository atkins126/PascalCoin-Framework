unit DevApp.Utils;

interface

uses PascalCoin.RPC.Interfaces, System.Classes, System.SysUtils;

Type

TDevAppUtils = Class
public
  class procedure AccountInfo(AAccount: IPascalCoinAccount; Strings: TStrings;
      const ExcludePubKey: Boolean = True); static;
  class function FormatAsTimeToGo(const ADate: TDateTime): string;
End;

implementation

uses System.DateUtils;

{ TDevAppUtils }

class procedure TDevAppUtils.AccountInfo(AAccount: IPascalCoinAccount; Strings: TStrings; const ExcludePubKey: Boolean = True);
begin
  Strings.Add('Account: ' + AAccount.account.ToString);
  Strings.Add('Name: ' + AAccount.Name);
  if Not ExcludePubkey then
     Strings.Add('enc_pubkey: ' + AAccount.enc_pubkey);
  Strings.Add('balance: ' + FormatFloat('#,000.0000', AAccount.balance));
  Strings.Add('balance_s: ' + AAccount.balance_s);
  Strings.Add('n_operation: ' + AAccount.n_operation.ToString);
  Strings.Add('updated_b: ' + AAccount.updated_b.ToString);
  Strings.Add('updated_b_active_mode: ' + AAccount.updated_b_active_mode.ToString);
  Strings.Add('updated_b_passive_mode: ' + AAccount.updated_b_passive_mode.ToString);
  Strings.Add('state: ' + AAccount.state);
  Strings.Add('locked_until_block: ' + AAccount.locked_until_block.ToString);
  Strings.Add('price: ' + FormatFloat('#,000.0000', AAccount.price));
  Strings.Add('seller_account: ' + AAccount.seller_account.ToString);
  Strings.Add('private_sale: ' + AAccount.private_sale.ToString(True));
  Strings.Add('new_enc_pubkey: ' + AAccount.new_enc_pubkey);
  Strings.Add('account_type: ' + AAccount.account_type.ToString);
  Strings.Add('Seal: ' + AAccount.Seal);
  Strings.Add('Data: ' + TEncoding.Unicode.GetString(AAccount.Data));
end;

class function TDevAppUtils.FormatAsTimeToGo(const ADate: TDateTime): string;
var y,m,d,h,n,s,z: word;
    r: string;
begin
  r := '';
    y := 0;
    m := 0;
    d := 0;
    h := 0;
    n := 0;
    s := 0;
    z := 0;

    if ADate >= 1 then
       DecodeDateTime(ADate + 1,y,m,d,h,n,s,z)
    else
       DecodeTime(ADate, h,n,s,z);

       y := y - 1900;
    if y > 0 then
       r := y.ToString + ' years ';

    if m > 0 then
    begin
       r := r + m.ToString + 'mths ';
       if y > 0 then
          Exit(r.Trim);
    end;

    if d > 0 then
    begin
      r := r + d.ToString+ ' days ';
      if m > 0 then
         Exit(r.Trim);
    end;

    if h > 0 then
    begin
       r := r + h.ToString + ' hours ';
       if d > 0 then
          exit(r.Trim);
    end;

    if n > 0 then
    begin
      r := r + n.ToString + ' mins ';
      if h > 0 then
         exit(r.Trim);
    end;

    result := '!!!!!!!!';

end;


end.
