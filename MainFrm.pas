unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, IdTCPServer, IdSimpleServer, DataPortIP,
  lNetComponents, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, laz2_DOM,
  Buttons, ComCtrls, MaskEdit, lNet, laz2_XMLRead, laz2_XMLWrite, Types;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnStart: TButton;
    btnClear: TButton;
    cbHex: TCheckBox;
    cbSave: TCheckBox;
    cbUdp: TCheckBox;
    cmbTemplate: TComboBox;
    cbLogLevel: TComboBox;
    edtPort: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LTCP1: TLTCPComponent;
    LUDP1: TLUDPComponent;
    MemoLog: TMemo;
    MemoSend: TMemo;
    Panel1: TPanel;
    sbSaveTemplate: TSpeedButton;
    sbDeleteTemplate: TSpeedButton;
    Splitter1: TSplitter;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure btnClearClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure cbSaveChange(Sender: TObject);
    procedure cmbTemplateCloseUp(Sender: TObject);
    procedure edtPortKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LTCP1Accept(aSocket: TLSocket);
    procedure LTCP1Disconnect(aSocket: TLSocket);
    procedure LTCP1Receive(aSocket: TLSocket);
    procedure LUDP1Receive(aSocket: TLSocket);
    procedure sbSaveTemplateClick(Sender: TObject);
    procedure sbDeleteTemplateClick(Sender: TObject);
  private

  public
    procedure loadXmlConfig();
    procedure saveXmlConfig();
    procedure printLog(strLog: string);
    function text2HexCode(str: string): string;
    procedure processLog(msg:String; cnt:Integer; mode:String; hex:Boolean; ts: TTimeStamp; aSocket: TLSocket);
  end;

var
  MainForm: TMainForm;
  xmlDoc: TXMLDocument;
  logFileHandle: THandle;

implementation

{$R *.frm}

{ TMainForm }

procedure TMainForm.btnClearClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
var
  port: word;
begin
  try
    port := StrToInt(edtPort.Text);
    if port > 65535 then
    begin
      ShowMessage('[ERROR]: The port is invalid, choose 1-65535.');
      exit;
    end;

    // start the server
    if btnStart.Tag = 0 then
    begin
      if cbUdp.Checked then
        LUDP1.Listen(port)
      else
        LTCP1.Listen(port);
      cbUdp.Enabled:=false;
      btnStart.Tag := 1;
    end
    else
    begin
      if cbUdp.Checked then
        LUDP1.Disconnect(True)
      else
        LTCP1.Disconnect(True);
      cbUdp.Enabled:=true;
      btnStart.Tag := 0;
    end;

    // change the display on the button.
    if btnStart.Tag = 0 then
    begin
      btnStart.Caption := '&Listen';
    end
    else
    begin
      btnStart.Caption := '&Stop';
    end;

  except
    on E: Exception do
      printLog('[ERROR]: ' + e.Message);
  end;

end;

procedure TMainForm.cbSaveChange(Sender: TObject);
begin
  if cbSave.Checked then
     printLog('Log will save to file...');
end;

procedure TMainForm.cmbTemplateCloseUp(Sender: TObject);
var
  pNode, tNode: TDOMNode;
begin
  // load the template
  pNode := xmlDoc.DocumentElement.FindNode('Template');
  if Assigned(pNode) then
  begin
    tNode := pNode.FirstChild;
    while Assigned(tNode) do
    begin
      if Assigned(tNode.Attributes.GetNamedItem('name')) and (tNode.Attributes.GetNamedItem('name').NodeValue = cmbTemplate.Text) then
      begin
        MemoSend.Text := tNode.TextContent;
      end;
      tNode := tNode.NextSibling;
    end;
  end;
end;

procedure TMainForm.edtPortKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (not (Key in [48..57, 8, 46])) then
  begin
    Key := 0;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  saveXmlConfig();
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  strTS: String;
begin
  try
  //init the xmlDoc
  xmlDoc := TXMLDocument.Create;
  strTS := DateTimeToStr(Now);
  strTS := strTS.Replace('/', '');
  strTS := strTS.Replace(':', '');
  strTS := strTS.Replace(' ', '');
  If Not DirectoryExists('log') then
    If Not CreateDir ('log') Then
      printLog('[ERROR]: Create dir log failed.');

  logFileHandle := FileCreate('.\log\mocalog_' + strTS + '.txt', fmOpenWrite);

  loadXmlConfig();
  except on e:Exception do
    printLog('[ERROR]:' + e.Message);
  end;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // destory the xml
  xmlDoc.Free;
  FileClose(logFileHandle);
end;

procedure TMainForm.LTCP1Accept(aSocket: TLSocket);
begin
  processLog('Connected.', 0, 'CLIENT', false, DateTimetoTimeStamp(Now), aSocket);
  //printLog('[CLIENT]:' + aSocket.PeerAddress + ':' + IntToStr(aSocket.PeerPort) + ' Connected.');
end;

procedure TMainForm.LTCP1Disconnect(aSocket: TLSocket);
begin
  processLog('Disconnected.', 0, 'CLIENT', false, DateTimetoTimeStamp(Now), aSocket);
  //printLog('[CLIENT]:' + aSocket.PeerAddress + ':' + IntToStr(aSocket.PeerPort) + ' Disconnected.');
end;

procedure TMainForm.LTCP1Receive(aSocket: TLSocket);
var
  recvMsg: string;
  recvCnt, sndCnt: integer;
  tsRecv, tsSend: TTimeStamp;
begin
  recvCnt := aSocket.GetMessage(recvMsg);
  tsRecv := DateTimeToTimeStamp (Now);  // Get the time of receive message
  sndCnt := aSocket.SendMessage(memoSend.Text);
  tsSend := DateTimeToTimeStamp (Now);  // Get the time of send message.

  if recvCnt > 0 then
  begin
    if cbLogLevel.Text = 'All' then
    begin
      processLog(recvMsg, recvCnt, 'RECV', cbHex.Checked, tsRecv, aSocket);
      processLog(memoSend.Text, sndCnt, 'SEND', cbHex.Checked, tsSend, aSocket);
    end;
  end;
end;

procedure TMainForm.LUDP1Receive(aSocket: TLSocket);
var
  recvMsg: string;
  recvCnt, sndCnt: integer;
  tsRecv, tsSend: TTimeStamp;
begin
  // tackle message.
  recvCnt := aSocket.GetMessage(recvMsg);
  tsRecv := DateTimeToTimeStamp (Now);  // Get the time of receive message
  sndCnt := aSocket.SendMessage(memoSend.Text);
  tsSend := DateTimeToTimeStamp (Now);  // Get the time of send message.

  if recvCnt > 0 then
  begin
    if cbLogLevel.Text = 'All' then
    begin
      processLog(recvMsg, recvCnt, 'RECV', cbHex.Checked, tsRecv, aSocket);
      processLog(memoSend.Text, sndCnt, 'SEND', cbHex.Checked, tsSend, aSocket);
    end;
  end;
end;

procedure TMainForm.sbSaveTemplateClick(Sender: TObject);
var
  pNode, tNode: TDOMNode;
begin
  pNode := xmlDoc.DocumentElement.FindNode('Template');
  if Assigned(pNode) then
  begin
    if cmbTemplate.ItemIndex <> -1 then
    begin
      tNode := pNode.FirstChild;
      while Assigned(tNode) do
      begin
        if tNode.Attributes.GetNamedItem('name').NodeValue = cmbTemplate.Text then
        begin
          tNode.TextContent := MemoSend.Text;
        end;
        tNode := tNode.NextSibling;
      end;
    end
    else
    begin
      // to avoid the duplicate item.
      tNode := pNode.FirstChild;
      while Assigned(tNode) do
      begin
        if tNode.Attributes.GetNamedItem('name').NodeValue = cmbTemplate.Text then
        begin
          tNode.TextContent := MemoSend.Text;
          exit; // find the same item, then finish the save process.
        end;
        tNode := tNode.NextSibling;
      end;
      // create new item below.
      tNode := xmlDoc.CreateElement('Item');
      tNode.TextContent := MemoSend.Text;
      TDomElement(tNode).SetAttribute('name', cmbTemplate.Text);
      pNode.AppendChild(tNode);
      cmbTemplate.Items.Append(cmbTemplate.Text);
    end;
  end;
end;

procedure TMainForm.sbDeleteTemplateClick(Sender: TObject);
var
  pNode, tNode: TDOMNode;
begin
  pNode := xmlDoc.DocumentElement.FindNode('Template');
  if Assigned(pNode) then
  begin
    if cmbTemplate.ItemIndex <> -1 then
    begin
      tNode := pNode.FirstChild;
      while Assigned(tNode) do
      begin
        if tNode.Attributes.GetNamedItem('name').NodeValue = cmbTemplate.Text then
        begin
          if MessageDlg ('Question', 'Are you sure delete the template?', mtConfirmation,
                  [mbYes, mbNo],0) = mrYes
          then
          begin
            pNode.RemoveChild(tNode);
            cmbTemplate.Items.Delete(cmbTemplate.ItemIndex);
            MemoSend.Clear;
          end;
        end;
        tNode := tNode.NextSibling;
      end;
    end
  end;
end;

procedure TMainForm.loadXmlConfig;
var
  pNode, tNode: TDomNode;
begin
  try
    ReadXMLFile(xmlDoc, 'Config.xml');

    // try to load template
    pNode := xmlDoc.DocumentElement.FindNode('Template');
    if pNode.HasChildNodes then
    begin
      tNode := pNode.FirstChild;
      while Assigned(tNode) do
      begin
        if Assigned(tNode.Attributes.GetNamedItem('name')) then
        begin
          cmbTemplate.Items.Append(tNode.Attributes.GetNamedItem('name').NodeValue);
        end;
        tNode := tNode.NextSibling;
      end;
    end;

    // try to load the config.
    pNode := xmlDoc.DocumentElement.FindNode('Application');
    if pNode.HasAttributes then
    begin
      if Assigned(pNode.Attributes.GetNamedItem('top')) and Assigned(pNode.Attributes.GetNamedItem('top')) and
        Assigned(pNode.Attributes.GetNamedItem('top')) and Assigned(pNode.Attributes.GetNamedItem('top')) and
        Assigned(pNode.Attributes.GetNamedItem('top')) then
      begin
        // layout init
        if Assigned(pNode.Attributes.GetNamedItem('top')) then
          MainForm.Top := StrToInt(pNode.Attributes.GetNamedItem('top').NodeValue);
        if Assigned(pNode.Attributes.GetNamedItem('left')) then
          MainForm.Left := StrToInt(pNode.Attributes.GetNamedItem('left').NodeValue);
        if Assigned(pNode.Attributes.GetNamedItem('height')) then
          MainForm.Height := StrToInt(pNode.Attributes.GetNamedItem('height').NodeValue);
        if Assigned(pNode.Attributes.GetNamedItem('width')) then
          MainForm.Width := StrToInt(pNode.Attributes.GetNamedItem('width').NodeValue);
        if Assigned(pNode.Attributes.GetNamedItem('split')) then
        begin
          Splitter1.SetSplitterPosition(StrToInt(pNode.Attributes.GetNamedItem('split').NodeValue));
        end;

        // config init
        if Assigned(pNode.Attributes.GetNamedItem('port')) then
          edtPort.Text := pNode.Attributes.GetNamedItem('port').NodeValue;
        if Assigned(pNode.Attributes.GetNamedItem('template_index')) then
        begin
          cmbTemplate.ItemIndex := StrToInt(pNode.Attributes.GetNamedItem('template_index').NodeValue);
          cmbTemplate.OnCloseUp(Self);
        end;
        if Assigned(pNode.Attributes.GetNamedItem('log_type')) then
          cbLogLevel.ItemIndex := StrToInt(pNode.Attributes.GetNamedItem('log_type').NodeValue);

        if Assigned(pNode.Attributes.GetNamedItem('hex')) and (pNode.Attributes.GetNamedItem('hex').NodeValue = '1') then
          cbHex.Checked := True
        else
          cbHex.Checked := False;
      end;
    end;

  except
    on e: Exception do
    begin
      printLog('[ERROR]: ' + e.Message);
    end;
  end;
end;

procedure TMainForm.saveXmlConfig;
var
  root, pNode: TDOMNode;
begin
  try
    if (not xmlDoc.HasChildNodes) or (xmlDoc.DocumentElement.NodeName <> 'MocaSimple') then
    begin
      ShowMessage('[ERROR] Config file is abnormal, the root element should not be ' + xmlDoc.DocumentElement.NodeName);
      // rebuild the xml config
      xmlDoc.RemoveChild(xmlDoc.DocumentElement);
      root := xmlDoc.CreateElement('MocaSimple');
      xmlDoc.AppendChild(root);
      root := xmlDoc.DocumentElement;

      //create application config.
      pNode := xmlDoc.CreateElement('Application');
      TDOMElement(pNode).SetAttribute('top', IntToStr(MainForm.Top));
      TDOMElement(pNode).SetAttribute('left', IntToStr(MainForm.Left));
      TDOMElement(pNode).SetAttribute('height', IntToStr(MainForm.Height));
      TDOMElement(pNode).SetAttribute('width', IntToStr(MainForm.Width));
      TDOMElement(pNode).SetAttribute('split', IntToStr(Splitter1.GetSplitterPosition));

      TDOMElement(pNode).SetAttribute('template_index', IntToStr(cmbTemplate.ItemIndex));
      TDOMElement(pNode).SetAttribute('port', edtPort.Text);
      TDOMElement(pNode).SetAttribute('log_type', IntToStr(cbLogLevel.ItemIndex));
      if cbHex.Checked then
        TDOMElement(pNode).SetAttribute('hex', '1')
      else
        TDOMElement(pNode).SetAttribute('hex', '0');
      root.AppendChild(pNode);

      pNode := xmlDoc.CreateElement('Template');
      root.AppendChild(pNode);

      pNode := xmlDoc.CreateElement('Rule');
      root.AppendChild(pNode);
    end
    else
    begin
      root := xmlDoc.DocumentElement;

      //if config exist, only save the global config.
      pNode := root.FindNode('Application');

      // save layout
      TDOMElement(pNode).SetAttribute('top', IntToStr(MainForm.Top));
      TDOMElement(pNode).SetAttribute('left', IntToStr(MainForm.Left));
      TDOMElement(pNode).SetAttribute('height', IntToStr(MainForm.Height));
      TDOMElement(pNode).SetAttribute('width', IntToStr(MainForm.Width));
      TDOMElement(pNode).SetAttribute('split', IntToStr(Splitter1.Top));

      // save config
      TDOMElement(pNode).SetAttribute('template_index', IntToStr(cmbTemplate.ItemIndex));
      TDOMElement(pNode).SetAttribute('port', edtPort.Text);
      TDOMElement(pNode).SetAttribute('log_type', IntToStr(cbLogLevel.ItemIndex));
      if cbHex.Checked then
        TDOMElement(pNode).SetAttribute('hex', '1')
      else
        TDOMElement(pNode).SetAttribute('hex', '0');
    end;


    writeXMLFile(xmlDoc, 'Config.xml');
  except
    on e: Exception do
    begin
      printLog('[ERROR]: ' + e.Message);
    end;
  end;
end;

procedure TMainForm.printLog(strLog: string);
var
  strTS: String;
  DT:TDateTime;
begin
  DT := Now;
  strTS := DateTimetoStr(DT) + Format('.%.3d', [DateTimeToTimeStamp(DT).Time mod 1000]);
  MemoLog.Append(strTS + ' ' + strLog);
end;

function TMainForm.text2HexCode(str: string): string;
var
  ret: string;
  i: integer;
begin
  // convert a string to hex code.
  ret := '';
  for i := 1 to Length(str) do
  begin
    ret := ret + Format('%.2x ', [Ord(str[i])]);
    if i mod 16 = 0 then
      ret := ret + chr(13) + chr(10);
  end;
  Result := ret;
end;

procedure TMainForm.processLog(msg: String; cnt: Integer; mode: String;
  hex: Boolean; ts: TTimeStamp; aSocket: TLSocket);
var
  str: String;
  strMsgLenIndicator: String;
  strSocketInfo: String;
begin
  // this procedure is used to show the log or save the log.
  if hex then
     msg := text2HexCode(msg);
  if (mode = 'SEND') or (mode = 'RECV') then
    strMsgLenIndicator := ' <' + IntToStr(cnt) + ' Bytes>' + chr(13) + chr(10) ;
  if Assigned(aSocket) then
    strSocketInfo :=aSocket.PeerAddress + ':' + IntToStr(aSocket.PeerPort) + '>';

  str := '[' + mode + ' ' + DateTimeToStr(TimeStampToDateTime(ts)) + '.' + Format('%.3d', [(ts.Time mod 1000)]) +']:<' +
   strSocketInfo + strMsgLenIndicator + msg;
  if cbSave.Checked then
  begin
    // save the log to file.
    str := str + #13#10;
    FileWrite(logFileHandle, str[1], Length(str));
  end
  else
      //if not save to file, then show log in memo.
      MemoLog.Append(str);
end;

end.
