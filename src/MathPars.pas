unit MathPars;

interface
uses
   SysUtils,uStack,math,classes;

type
TMathParser = class(TComponent)
   private
      FSymbolLine  :Integer;
      FSymbolPos   :Integer;
      FPos         :Integer;//позиция курсора
      FExpression  :String;
      Polis        :TStack;
      Stack        :TStack;
      FVariables: TStrings;
      procedure SetExpression(const Value: String);
      procedure SetVariables(const Value: TStrings);
    function GetExpression: String;
   protected
      function CheckRules(FirstLex,SecondLex:TLexemType):boolean;virtual;// Проверить правило
      procedure ChangeMinusToTwiddle;virtual;
      procedure LexicalAnalysis;virtual;
      procedure MissSpace;virtual;
      function DefineLexemType(FirstChar:Char):TLexemType;
      function GetLexem:TLexeme;//Выделить  лексему
      procedure AddPolis(Lexeme:TLexeme);
      function GetPrec(Lex:String):Integer;
      function CalculFunction(FunName:String;Value:String):String;
      function CalculBinOp(OpName:String;Value1,Val2:String):String;
      function CalculUnarOp(OpName:String;Value:String):String;
      function GetVarValue(Variable:String):String;
      procedure Calcul;
   public
      constructor Create(AOwner: TComponent);override;
      destructor Destroy;override;
      function Execute:Real;
   published
      property Expression:String read GetExpression write SetExpression;
      property Variables:TStrings read FVariables write SetVariables;
    end;

EUntrueSequence = class(Exception);
EUnknownSymbol = class(Exception);
EUndeclaredIdentifier=class(Exception);
EUnknownFunction=class(Exception);

procedure Register;
implementation
{ TMathParser }
const//таблица правил
   RulesTable: array[TLexemType,TLexemType] of Boolean=
     (
       (true,false,true,true,true,false,true),
       (false,true,false,false,false,true,false),
       (false,true,false,false,false,true,false),
       (false,true,false,false,false,true,false),
       (true,false,false,false,false,false,false),
       (true,false,true,true,true,false,false),
       (true,false,true,true,true,false,false)
     );

const//название типов лексем
     LexTypeName:array[TLexemType] of String=
     ('(',')','число','Переменная','функция','Бинарная операция','Унарная операция');

constructor TMathParser.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Polis:=TStack.Create;
    Stack:=TStack.Create;
    FVariables:=TStringList.Create;
end;

destructor TMathParser.Destroy;
begin
  Polis.Free;
  Stack.Free;
  FVariables.Free;
  inherited;
end;

//замена унарного минуса на тильду
procedure TMathParser.ChangeMinusToTwiddle;
begin
   while Pos('(-',FExpression)<>0 do// унарный минус
      FExpression[Pos('(-',FExpression)+1]:='~';
end;

//пропустить все пробелы табуляцию ВК
procedure TMathParser.MissSpace;
begin
  while true do
  begin
    case FExpression[FPos] of
     #9,' ':  Inc(FSymbolPos);
     #13   :  Inc(FSymbolLine);
    else  Break
    end;
   Inc(FPos);
  end
end;

function TMathParser.DefineLexemType(FirstChar: Char): TLexemType;
begin
      case FirstChar of
          '0'..'9'           :Result:=ltNumber;
          'a'..'z','_'           :Result:=ltVariable;
          '+','-','/','*','^':Result:=ltBinOp;
          '~'                :Result:=ltUnOp;
          '('                :Result:=ltOpenBrick;
          ')'                :Result:=ltCloseBrick;
       else
         raise
           EUnknownSymbol.CreateFmt('Недопусптимый символ %s %d',[FExpression[FPos-1],FPos-1]);
       end
end;

function TMathParser.GetLexem: TLexeme;
begin
   Result.LexType:=DefineLexemType(FExpression[FPos]);
   Result.Str:=FExpression[FPos];
   Inc(FPos);
   if  Result.LexType in [ltBinOp,ltUnOp,ltOpenBrick,ltCloseBrick] then  Exit;
   while true do
   begin
        case FExpression[FPos] of
          '+','-','/','*','^',')','~',' ',#8,#13:break;
          '0'..'9' :Result.str:=Result.str+FExpression[FPos];
          'a'..'z','_': if Result.LexType=ltNumber then break
                    else Result.Str:=Result.str+FExpression[FPos];
          '('      :begin
                    if Result.LexType=ltVariable then
                    begin
                        Result.LexType:=ltFunction;
                        break;
                    end
                       else break
                    end;
        else
            EUnknownSymbol.CreateFmt('Недопусптимый символ %s %d',[FExpression[FPos-1],FPos-1]);
        end;
       Inc(FPos);
   end;

end;


//лексический анализатор
procedure TMathParser.LexicalAnalysis;
var
   Lexeme,PrevLexem:TLexeme;
begin
   Polis.Clear;
   Stack.Clear;
   ChangeMinusToTwiddle;
   FPos:=2;
   PrevLexem.str:='(';
   PrevLexem.LexType:=ltOpenBrick;
   Stack.Push(PrevLexem);
   while FPos<=Length(FExpression) do
   begin
      MissSpace;
      Lexeme:=GetLexem;
      if CheckRules(PrevLexem.LexType,Lexeme.LexType)then
      else
        raise EUntrueSequence.Create(
            LexTypeName[PrevLexem.LexType]+' не может следовать за '+
            LexTypeName[Lexeme.LexType]);
      PrevLexem:=Lexeme;
      AddPolis(Lexeme);
   end;
   //Modify:=false;
end;



procedure TMathParser.SetExpression(const Value: String);
begin
  if  FExpression <>'('+ Value+')' then
  begin
     FExpression :='('+ Value+')';

  end;
end;

function TMathParser.CheckRules(FirstLex, SecondLex: TLexemType): boolean;
begin
    Result:=RulesTable[FirstLex,SecondLex];
end;

procedure TMathParser.AddPolis(Lexeme: TLexeme);
begin
      case Lexeme.LexType of//если входная лексема
      ltNumber,ltVariable: Polis.Push(Lexeme);//число или переменная перенести ее в полиз без изменения
      ltOpenBrick: Stack.Push(Lexeme); // если открывающая скобка, поместить ее в стек
      ltCloseBrick: // если закрывающая скобка,
           begin
               //вытолкивать все из стека и помещать в полиз, пока не встретится открывающая скобка
               while Stack.Top.LexType<>ltOpenBrick do
                   Polis.Push(Stack.Pop);
               Stack.Pop;//вытолкнуть открывающую скобку
           end;
      else begin
            while GetPrec(Lexeme.Str)<=GetPrec(Stack.Top.Str) do
               Polis.Push(Stack.Pop);
            Stack.Push(Lexeme);
           end;
      end;
end;

function TMathParser.Execute: Real;
begin
    LexicalAnalysis;
    Calcul;
    Result:=StrToFloat(Polis.Items[0].Str);
end;

function TMathParser.GetPrec(Lex: String): Integer;
begin
     if Lex='~' then Result:=4
     else
     if  (Lex='+') or (Lex='-') then Result:=1
     else
     if  (Lex='*') or (Lex='/') then Result:=2
     else
     if Lex='^' then Result:=3
     else
     if Lex='(' then  Result:=-1
     else
     Result:=5;
end;

function TMathParser.CalculFunction(FunName, Value: String): String;
begin
     if FunName='arctan' then
         Result:=FloatToStr(ArcTan(StrToFloat(Value)))
     else if FunName='exp' then
         Result:=FloatToStr(exp(StrToFloat(Value)))
     else if FunName='sin' then
         Result:=FloatToStr(sin(StrToFloat(Value)))
     else if FunName='cos' then
         Result:=FloatToStr(cos(StrToFloat(Value)))
     else if FunName='tan' then
         Result:=FloatToStr(tan(StrToFloat(Value)))
     else if FunName='sqrt' then
         Result:=FloatToStr(sqrt(StrToFloat(Value)))
     else raise   EUnknownFunction.CreateFmt('Неизвестная символ %s %d',[FunName,FPos-1]);
end;

function TMathParser.CalculBinOp(OpName, Value1, Val2: String): String;
begin
    if  OpName='+' then
         Result:=FloatToStr(StrToFloat(Value1)+StrToFloat(Val2))
    else if OpName='-' then
         Result:=FloatToStr(StrToFloat(Value1)-StrToFloat(Val2))
    else if OpName='*' then
         Result:=FloatToStr(StrToFloat(Value1)*StrToFloat(Val2))
    else if OpName='/' then
         Result:=FloatToStr(StrToFloat(Value1)/StrToFloat(Val2))
    else if OpName='^' then
         Result:=FloatToStr(Power(StrToFloat(Value1),StrToFloat(Val2)));
end;

function TMathParser.CalculUnarOp(OpName, Value: String): String;
begin
    if OpName='~' then Result:=FloatToStr(-StrToFloat(Value));
end;

procedure TMathParser.Calcul;
var
   i:Integer;
   Lexeme:TLexeme;
begin
   i:=0;
   Lexeme.LexType:=ltNumber;
   while true do
   begin
     case Polis[i].LexType of
        ltVariable: begin
                       Lexeme.Str:=GetVarValue(Polis[i].Str);
                       Polis[i]:=Lexeme;
                    end;
        ltFunction:begin
                       Lexeme.Str:=CalculFunction(Polis[i].Str,Polis[i-1].Str);
                       Polis[i-1]:=Lexeme;
                       Polis.Delete(i);
                   end;
        ltUnOp    :begin
                       Lexeme.Str:=CalculUnarOp(Polis[i].Str,Polis[i-1].Str);
                       Polis[i-1]:=Lexeme;
                       Polis.Delete(i);
                   end;
        ltBinOp   :begin
                     Lexeme.Str:=CalculBinOp(Polis[i].Str,Polis[i-2].Str,Polis[i-1].Str);
                     Polis[i-2]:=Lexeme;
                     Polis.Delete(i);
                     Polis.Delete(i-1);
                     i:=i-1;
                    end;
        else
            Inc(i);
      end;
      if Polis.Count=1 then Break;
    end;
end;


procedure TMathParser.SetVariables(const Value: TStrings);
begin
   FVariables.Assign(Value);
end;

function TMathParser.GetVarValue(Variable: String): String;
begin
    Result:=FVariables.Values[Variable];
    if Result='' then raise EUndeclaredIdentifier.
           Create('Неопределенный символ '+Variable);
end;

function TMathParser.GetExpression: String;
begin
     Result:=Copy(FExpression,2,Length(FExpression)-2);
end;

procedure Register;
begin
  RegisterComponents('Math Components', [TMathParser]);
end;


end.
