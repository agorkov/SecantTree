unit uStack;

interface
type
  TLexemType=
    (
       ltOpenBrick, //открывающая скобка
       ltCloseBrick,//закрывающая скобка
       ltNumber,    //число
       ltVariable,  //Перменная||константа
       ltFunction,  //функция
       ltBinOp,     //бинарная операция
       ltUnOp       //унарная операция
     );
 TLexeme= record
        Str:String;
        LexType:TLexemType;
        end;

   TElements=TLexeme;

 TStack = class
  private
    FDepth:Integer;
    FItems :array of TElements;
    FCount: Integer;
    function GetItems(Index: Integer): TElements;
    procedure SetItems(Index: Integer; const Value: TElements);
  public
    procedure Push(Value:TElements);virtual;
    function  Pop:TElements;virtual;
    function  Top:TElements;virtual;
    procedure Delete(Index:Integer);
    procedure Clear;
    constructor Create();
    property Count:Integer read FCount;
    property Items[Index:Integer]:TElements read GetItems write SetItems; default;
  end;


implementation

{ TStack }

procedure TStack.Clear;
begin
   FDepth:=30;
   FCount:=0;
   SetLength(FItems,FDepth);
end;

constructor TStack.Create;
begin
     FDepth:=50;
     FCount:=0;
     SetLength(FItems,FDepth);
end;

procedure TStack.Delete(Index: Integer);
var
   i:Integer;
begin
    for i:=Index to FCount-2 do
        FItems[i]:=FItems[i+1];
    Dec(FCount);
end;

function TStack.GetItems(Index: Integer): TElements;
begin
     Result:=FItems[Index];
end;

function TStack.Pop: TElements;
begin
     Result:=FItems[Count-1];
     Dec(FCount);
end;

procedure TStack.Push(Value:TElements);
begin
{      if FCount=FDepth then
      begin
         Inc(FDepth,30);
         SetLength(FItems,FDepth);
      end;}
      FItems[Count]:=Value;
      Inc(FCount);

end;

procedure TStack.SetItems(Index: Integer; const Value: TElements);
begin
      FItems[Index]:=Value
end;

function TStack.Top: TElements;
begin
     Result:=FItems[Count-1];
end;

end.
