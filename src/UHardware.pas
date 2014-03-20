unit UHardware;

interface

uses
  SysUtils;

procedure HW;

implementation

uses
  UGlobal, UFMain, UTree;

const
  DIR = 'HW\';
  INPUT_BLOCK_FILE_NAME = DIR + 'INPUT_BLOCK.vhd';
  TREE_CODE_FILE_NAME = DIR + 'TREE_CODE.vhd';
  OUTPUT_BLOCK_FILE_NAME = DIR + 'OUTPUT_BLOCK.vhd';
  TREE_FILE_NAME = DIR + 'TREE.vhd';

procedure Create_INPUT_BLOCK;
var
  f: TextFile;
begin
  UFMain.Info('Аппаратная реализация (блок ввода)', 0, 0);
  AssignFile(f, INPUT_BLOCK_FILE_NAME);
  rewrite(f);
  writeln(f, 'LIBRARY ieee;');
  writeln(f, 'USE ieee.std_logic_1164.all;');
  writeln(f, '');
  writeln(f, 'ENTITY INPUT_BLOCK IS');
  writeln(f, '  PORT');
  writeln(f, '  (');
  writeln(f, '    C, SERIAL_INPUT, TIMING : IN  std_logic;');
  writeln(f, '    PARALLEL_OUTPUT : OUT std_logic_vector(' + inttostr(AIS.m - 1) + ' DOWNTO 0)');
  writeln(f, '  );');
  writeln(f, 'END INPUT_BLOCK;');
  writeln(f, '');
  writeln(f, 'ARCHITECTURE archi OF INPUT_BLOCK IS');
  writeln(f, 'signal tmp: std_logic_vector(' + inttostr(AIS.m - 1) + ' DOWNTO 0);');
  writeln(f, 'constant clk_freq : integer := 50_000_000;');
  writeln(f, 'constant btn_wait : integer := clk_freq/8;');
  writeln(f, 'signal count : integer range 0 to btn_wait := 0;');
  writeln(f, 'BEGIN');
  writeln(f, 'process(timing)');
  writeln(f, 'begin');
  writeln(f, '  if rising_edge(timing) then');
  writeln(f, '  if C = ''0'' then');
  writeln(f, '  count <= count + 1;');
  writeln(f, '  if count = btn_wait then');
  writeln(f, '  FOR i IN 0 TO ' + inttostr(AIS.m - 2) + ' LOOP');
  writeln(f, '  tmp(i+1) <= tmp(i);');
  writeln(f, '  END LOOP;');
  writeln(f, '  tmp(0) <= SERIAL_INPUT;');
  writeln(f, '  count <= 0;');
  writeln(f, '  end if;');
  writeln(f, '  else');
  writeln(f, '  count <= 0;');
  writeln(f, '  end if;');
  writeln(f, '  end if;');
  writeln(f, '  end process;');
  writeln(f, '  PARALLEL_OUTPUT <= tmp;');
  writeln(f, '  END archi;');
  CloseFile(f);
  RemoveInfo;
end;

procedure Create_TREE;
var
  f: TextFile;
  i, LengthCode: LongWord;
begin
  UFMain.Info('Построение дерева', 0, 0);

  LengthCode := 0;
  for i := 1 to LengthTree - 1 do
    if length(Tree[i].trajectory) > LengthCode then
      LengthCode := length(Tree[i].trajectory);

  AssignFile(f, TREE_FILE_NAME);
  rewrite(f);
  writeln(f, 'LIBRARY ieee;');
  writeln(f, 'USE ieee.std_logic_1164.all;');
  writeln(f, '');
  writeln(f, 'ENTITY TREE IS');
  writeln(f, '  PORT');
  writeln(f, '  (');
  writeln(f, '    DIGIT :  IN  STD_LOGIC;');
  writeln(f, '    CLOCK :  IN  STD_LOGIC;');
  writeln(f, '    GTIME :  IN  STD_LOGIC;');
  writeln(f, '    COMPRESSED_CODE :  OUT  STD_LOGIC_VECTOR(' + inttostr(LengthCode - 1) + ' DOWNTO 0)');
  writeln(f, '  );');
  writeln(f, 'END TREE;');
  writeln(f, '');
  writeln(f, 'ARCHITECTURE archi OF TREE IS');
  writeln(f, '');

  writeln(f, 'COMPONENT INPUT_BLOCK');
  writeln(f, '  PORT');
  writeln(f, '  (');
  writeln(f, '    C : IN STD_LOGIC;');
  writeln(f, '    TIMING : IN STD_LOGIC;');
  writeln(f, '    SERIAL_INPUT : IN STD_LOGIC;');
  writeln(f, '    PARALLEL_OUTPUT : OUT STD_LOGIC_VECTOR(' + inttostr(AIS.m - 1) + ' DOWNTO 0)');
  writeln(f, ');');
  writeln(f, 'END COMPONENT;');
  writeln(f, '');

  writeln(f, 'COMPONENT TREE_CODE');
  writeln(f, '  PORT');
  writeln(f, '  (');
  writeln(f, '    DIGITS : IN STD_LOGIC_VECTOR(' + inttostr(AIS.m - 1) + ' DOWNTO 0);');
  writeln(f, '    IMAGES : OUT STD_LOGIC_VECTOR(' + inttostr(LengthCode - 1) + ' DOWNTO 0)');
  writeln(f, '  );');
  writeln(f, 'END COMPONENT;');
  writeln(f, '');

  writeln(f, 'signal	IMAGES_BIN_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(' + inttostr(LengthCode - 1) + ' DOWNTO 0);');
  writeln(f, 'signal	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(' + inttostr(AIS.n - 1) + ' downto 0);');
  writeln(f, 'signal	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(' + inttostr(AIS.m - 1) + ' downto 0);');
  writeln(f, '');

  writeln(f, 'BEGIN');

  writeln(f, 'b2v_inst : INPUT_BLOCK');
  writeln(f, '  PORT MAP');
  writeln(f, '  (');
  writeln(f, '    C => CLOCK,');
  writeln(f, '    TIMING => GTIME,');
  writeln(f, '    SERIAL_INPUT => DIGIT,');
  writeln(f, '    PARALLEL_OUTPUT => SYNTHESIZED_WIRE_1');
  writeln(f, '  );');
  writeln(f, '');

  writeln(f, 'b2v_inst4 : TREE_CODE');
  writeln(f, '  PORT MAP');
  writeln(f, '  (');
  writeln(f, '    DIGITS => SYNTHESIZED_WIRE_1,');
  writeln(f, '    IMAGES => IMAGES_BIN_ALTERA_SYNTHESIZED');
  writeln(f, '  );');
  writeln(f, '');

  writeln(f, '  COMPRESSED_CODE <= IMAGES_BIN_ALTERA_SYNTHESIZED;');
  writeln(f, '');

  writeln(f, 'END;');
  CloseFile(f);
  UFMain.RemoveInfo;
end;

procedure Create_Tree_Code;
  procedure CreateNode(DigitCount: LongWord);
  var
    f: TextFile;
    i: LongWord;
    str: string;
  begin
    AssignFile(f, DIR + 'treenode' + inttostr(DigitCount) + '.vhd');
    rewrite(f);
    writeln(f, 'LIBRARY ieee;');
    writeln(f, 'USE ieee.std_logic_1164.all;');
    writeln(f, '');
    writeln(f, 'LIBRARY work;');
    writeln(f, '');
    writeln(f, 'ENTITY TreeNode' + inttostr(DigitCount) + ' IS');
    writeln(f, 'PORT');
    writeln(f, '(');
    writeln(f, 'DIGIT :  IN  STD_LOGIC_VECTOR(' + inttostr(DigitCount - 1) + ' DOWNTO 0);');
    writeln(f, 'DIGIT_VALUE :  IN  STD_LOGIC_VECTOR(' + inttostr(DigitCount - 1) + ' DOWNTO 0);');
    writeln(f, 'PREV :  IN  STD_LOGIC;');
    writeln(f, 'UP :  OUT  STD_LOGIC;');
    writeln(f, 'DOWN :  OUT  STD_LOGIC');
    writeln(f, ');');
    writeln(f, 'END TreeNode' + inttostr(DigitCount) + ';');
    writeln(f, '');
    writeln(f, 'ARCHITECTURE bdf_type OF TreeNode' + inttostr(DigitCount) + ' IS');
    writeln(f, 'signal tmp: STD_LOGIC;');
    writeln(f, 'BEGIN');
    str := '';
    for i := 0 to DigitCount - 1 do
      str := str + ' AND (DIGIT(' + inttostr(i) + ') XNOR DIGIT_VALUE(' + inttostr(i) + '))';
    str := str + ';';
    delete(str, 1, 5);
    writeln(f, 'tmp<=' + str);
    writeln(f, 'UP<=PREV AND tmp;');
    writeln(f, 'DOWN<=PREV AND (NOT tmp);');
    writeln(f, 'END bdf_type;');
    CloseFile(f);
  end;

var
  i, j, LengthCode: LongWord;
  str: string;
  f: TextFile;
begin
  LengthCode := 0;
  for i := 1 to LengthTree - 1 do
    if length(Tree[i].trajectory) > LengthCode then
      LengthCode := length(Tree[i].trajectory);

  ///
  /// Заголовоченая часть
  ///
  AssignFile(f, TREE_CODE_FILE_NAME);
  rewrite(f);
  writeln(f, 'LIBRARY ieee;');
  writeln(f, 'USE ieee.std_logic_1164.all;');
  writeln(f, 'USE work.all;');
  writeln(f);
  writeln(f, 'ENTITY TREE_CODE IS');
  writeln(f, '  PORT');
  writeln(f, '  (');
  writeln(f, '    DIGITS : IN std_logic_vector (' + inttostr(AIS.m - 1) + ' DOWNTO 0);');
  writeln(f, '    IMAGES : OUT std_logic_vector (' + inttostr(LengthCode - 1) + ' DOWNTO 0)');
  writeln(f, '  );');
  writeln(f, 'END TREE_CODE;');
  writeln(f);
  writeln(f, 'ARCHITECTURE archi OF TREE_CODE IS');
  writeln(f);
  ///
  /// Объявление узлов
  ///
  for i := 1 to LengthTree - 1 do
  begin
    UFMain.Info('Аппаратная реализация (код дерева (объявление узлов)) ', i, LengthTree - 1);
    if (Tree[i].DSec.DigitCount > 0) and (not FileExists(DIR + 'TreeNode' + inttostr(Tree[i].DSec.DigitCount) + '.vhd')) then
    begin
      CreateNode(Tree[i].DSec.DigitCount);
      writeln(f, 'COMPONENT treenode' + inttostr(Tree[i].DSec.DigitCount));
      writeln(f, 'PORT(PREV : IN STD_LOGIC;');
      writeln(f, 'DIGIT :  IN  STD_LOGIC_VECTOR(' + inttostr(Tree[i].DSec.DigitCount - 1) + ' DOWNTO 0);');
      writeln(f, 'DIGIT_VALUE :  IN  STD_LOGIC_VECTOR(' + inttostr(Tree[i].DSec.DigitCount - 1) + ' DOWNTO 0);');
      writeln(f, 'UP : OUT STD_LOGIC;');
      writeln(f, 'DOWN : OUT STD_LOGIC');
      writeln(f, ');');
      writeln(f, 'END COMPONENT;');
    end;
  end;
  ///
  /// Объявление сигналов
  ///
  for i := 1 to LengthTree - 1 do
  begin
    UFMain.Info('Аппаратная реализация (код дерева (объявление сигналов)) ', i, LengthTree - 1);
    if Tree[i].DSec.DigitCount > 0 then
    begin
      writeln(f, 'SIGNAL	WN' + inttostr(i) + 'U :  STD_LOGIC;');
      writeln(f, 'SIGNAL	WN' + inttostr(i) + 'D :  STD_LOGIC;');
    end;
  end;
  writeln(f, 'SIGNAL WGND :  STD_LOGIC;');
  writeln(f, 'SIGNAL WVCC :  STD_LOGIC;');
  writeln(f, 'BEGIN');
  writeln(f, 'WGND <= ''0'';');
  writeln(f, 'WVCC <= ''1'';');
  ///
  /// Реализация дерева
  ///
  for i := 1 to LengthTree - 1 do
  begin
    UFMain.Info('Аппаратная реализация (код дерева (трассировка)) ', i, LengthTree - 1);
    if Tree[i].DSec.DigitCount > 0 then
    begin
      writeln(f, 'b2v_N' + inttostr(i) + ' : treenode' + inttostr(Tree[i].DSec.DigitCount));
      writeln(f, 'PORT MAP(');
      /// PREV ///
      if i > 1 then
      begin
        if Tree[i].num = Tree[Tree[i].prev].next then
          writeln(f, 'PREV => WN' + inttostr(Tree[Tree[i].prev].num) + 'U,')
        else
          writeln(f, 'PREV => WN' + inttostr(Tree[Tree[i].prev].num) + 'D,')
      end
      else
        writeln(f, 'PREV => WVCC,');
      /// DIGIT ///
      for j := 1 to Tree[i].DSec.DigitCount do
        writeln(f, 'DIGIT(' + inttostr(j - 1) + ') => DIGITS(' + inttostr(Tree[i].DSec.Sec[j].digit - 1) + '),');
      /// DIGIT_VALUE ///
      for j := 1 to Tree[i].DSec.DigitCount do
        if Tree[i].DSec.Sec[j].value then
          writeln(f, 'DIGIT_VALUE(' + inttostr(j - 1) + ') => WVCC,')
        else
          writeln(f, 'DIGIT_VALUE(' + inttostr(j - 1) + ') => WGND,');
      /// UP ///
      writeln(f, 'UP => WN' + inttostr(i) + 'U,');
      /// DOWN ///
      writeln(f, 'DOWN => WN' + inttostr(i) + 'D);')
    end;
  end;

  for i := 0 to LengthCode - 1 do
  begin
    str := '''0''';
    for j := 1 to LengthTree - 1 do
      if (length(Tree[j].trajectory) = i) and (Tree[j].ActiveCount > 1) then
        str := str + ' OR WN' + inttostr(Tree[j].num) + 'U';
    writeln(f, 'IMAGES(' + inttostr(i) + ')<=' + str + ';');
  end;

  writeln(f, 'END;');
  CloseFile(f);
end;

procedure HW;
  procedure DeleteOldData;
  var
    SR: TSearchRec;
    FR: Integer;
    f: file;
  begin
    FR := FindFirst(DIR + '*.*', faAnyFile, SR);
    while FR = 0 do
    begin
      if (pos('.qpf', SR.Name) = 0) and (pos('.vwf', SR.Name) = 0) and (SR.Attr <> 16) then
      begin
        AssignFile(f, DIR + SR.Name);
        Erase(f);
      end;
      FR := FindNext(SR);
    end;
  end;

begin
  DeleteOldData;
  Create_INPUT_BLOCK;
  Create_Tree_Code;
  Create_TREE;
end;

end.
