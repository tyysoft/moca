object MainForm: TMainForm
  Left = 319
  Height = 566
  Top = 187
  Width = 768
  Caption = 'MocaSimple v1.1 Powered by TYYSOFT! '
  ClientHeight = 566
  ClientWidth = 768
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  LCLVersion = '6.2'
  object ToolBar1: TToolBar
    Left = 0
    Height = 26
    Top = 0
    Width = 768
    Caption = 'ToolBar1'
    TabOrder = 0
    object sbSaveTemplate: TSpeedButton
      Left = 233
      Height = 22
      Hint = 'Save template'
      Top = 2
      Width = 23
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000064000000640000000000000000000000C1761BC27519
        BD6B13B96504B96504B96504BA6504BA6504BA6504BA6504B96504B96504B965
        04B96504B96A15C77B25D5933DEFB736CDC6C0E9F6FFDBE7F8DBE8F8DBE8F9DB
        E8F9DBE8F8D8E4F5DAE7F8D8E4F5E9F6FFCDC6C0EAA714C77B25D5933DEFB736
        CDC6C0E9F6FFDBE7F8DBE8F8DBE8F9DBE8F9DBE8F8D8E4F5DAE7F8D8E4F5E9F6
        FFCDC6C0EAA714C77B25CD9551E8AE3CDCD7D4ECE8E9ADA0A2A99D9F9E939594
        898C8A818582797C7B7276685F64ECE8E9DCD7D4E59E20C77B25D09653EAB447
        DCD7D4EFF0EFE0DFDDE1DFDDE1DFDDDFE0DEE1E0DFDDDDDDDFE0DEDBD9D9EDED
        EDDCD7D4E7A62BC77B25D49B58EBB950DCD7D4ECEBE8A99D9FA4999E9A919492
        888B897F8582797C7A7177655C62ECEBE8DCD7D4E8AC37CC8531D69E5BEDBD5A
        DCD7D4FFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFE
        FEDCD7D4E8AE3CD08B34D8A35CF0C263DCD7D4ECEBE8A99D9FA4999E9A919492
        888B8A818582797C7A7177655C62ECEBE8DCD7D4EAB447D2903AD8A35CF0C66D
        DCD7D4FFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFEFEFFFE
        FEDCD7D4EEBD54D99B44DEAC69F9D281C1975C9A7B6095775E95775E97795C97
        795C97795C97795C97795C95775E97795CC19A64F7CA6BD99B44DCA966F6D58B
        FFD056C0A888C8C5C9CEC6BFCEC6BFCDC6C0CDC6C0D6D0CAD6D3D0CFCED4C0A8
        88FFD25DF3CC75DCA148DCA966F6D993FBC85DC2B4A2D7DEEBDDDDDDDDDDDDDD
        DDDDE7E8EAC8BAA7A29692C2B4A2C6BCA9FBCB63F3D07EE0A74CE5B973F6DA97
        FBCC62C8BAA7DDE0E9E1E0DFE1E0DFDDDDDDEFF3F99F886FE5AF479E9189C7BD
        B2FDCF69F5D484E3AC51E9BC75F8DD9EFDCF69CEC0AFE3E7EFE5E4E2E6E5E4E5
        E4E2F1F6FFBAA386FFE873B5AB9ECAC0B8FFD26EF9DA8EE7B25BEAC079F8E09B
        FBD165D3C4AFEAEEF6ECEBE9ECEBE8EBE9E6FBFFFFA28E78DEAF4FA89C95D1C7
        B9FFDA78F5D889E2A442ECC47EFEF4D5FFE290DCD7D4F6FEFFF6FEFFF6FEFFF6
        FEFFFFFEFEDFDDDCC8BAA7DDDDDDE5E4E2FFDE88E4AA45FCF5EB
      }
      OnClick = sbSaveTemplateClick
    end
    object cmbTemplate: TComboBox
      Left = 61
      Height = 22
      Top = 2
      Width = 172
      AutoComplete = True
      AutoCompleteText = [cbactEnabled, cbactEndOfLineComplete, cbactSearchAscending]
      AutoDropDown = True
      ItemHeight = 16
      OnCloseUp = cmbTemplateCloseUp
      Style = csOwnerDrawEditableVariable
      TabOrder = 0
    end
    object Label1: TLabel
      Left = 1
      Height = 22
      Top = 2
      Width = 60
      AutoSize = False
      Caption = 'Auto Send:'
      Layout = tlCenter
      ParentColor = False
    end
    object btnStart: TButton
      Left = 403
      Height = 22
      Top = 2
      Width = 53
      Caption = '&Listen'
      OnClick = btnStartClick
      TabOrder = 1
    end
    object Label2: TLabel
      Left = 287
      Height = 22
      Top = 2
      Width = 36
      AutoSize = False
      Caption = 'Port:'
      Layout = tlCenter
      ParentColor = False
    end
    object edtPort: TEdit
      Left = 323
      Height = 25
      Top = 2
      Width = 80
      OnKeyDown = edtPortKeyDown
      TabOrder = 2
      Text = '8888'
    end
    object ToolButton1: TToolButton
      Left = 279
      Height = 22
      Top = 2
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object sbDeleteTemplate: TSpeedButton
      Left = 256
      Height = 22
      Hint = 'Delte template'
      Top = 2
      Width = 23
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        080000000000000100000000000000000000000000000000000000000000FFFF
        FF002928DE003130C6007371F700312CE700312CDE003934E7006B65F7002118
        C6002920C6003128C6003930E7006B61F7002110C6006355F700C6C3E7002918
        C6005A49F700523CF7007365D600AD9EDE004259CE007B8AD6004A5DCE005A6D
        CE004255CE004251CE003945CE005A61E7007B82F7004A51E700393CC600A5A6
        DE00FFFFFF0000336600003399000033CC000033FF0000660000006633000066
        6600006699000066CC000066FF00009900000099330000996600009999000099
        CC000099FF0000CC000000CC330000CC660000CC990000CCCC0000CCFF0000FF
        660000FF990000FFCC00330000003300330033006600330099003300CC003300
        FF00333300003333330033336600333399003333CC003333FF00336600003366
        330033666600336699003366CC003366FF003399000033993300339966003399
        99003399CC003399FF0033CC000033CC330033CC660033CC990033CCCC0033CC
        FF0033FF330033FF660033FF990033FFCC0033FFFF0066000000660033006600
        6600660099006600CC006600FF00663300006633330066336600663399006633
        CC006633FF00666600006666330066666600666699006666CC00669900006699
        330066996600669999006699CC006699FF0066CC000066CC330066CC990066CC
        CC0066CCFF0066FF000066FF330066FF990066FFCC00CC00FF00FF00CC009999
        000099339900990099009900CC009900000099333300990066009933CC009900
        FF00996600009966330099336600996699009966CC009933FF00999933009999
        6600999999009999CC009999FF0099CC000099CC330066CC660099CC990099CC
        CC0099CCFF0099FF000099FF330099CC660099FF990099FFCC0099FFFF00CC00
        000099003300CC006600CC009900CC00CC0099330000CC333300CC336600CC33
        9900CC33CC00CC33FF00CC660000CC66330099666600CC669900CC66CC009966
        FF00CC990000CC993300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC
        3300CCCC6600CCCC9900CCCCCC00CCCCFF00CCFF0000CCFF330099FF6600CCFF
        9900CCFFCC00CCFFFF00CC003300FF006600FF009900CC330000FF333300FF33
        6600FF339900FF33CC00FF33FF00FF660000FF663300CC666600FF669900FF66
        CC00CC66FF00FF990000FF993300FF996600FF999900FF99CC00FF99FF00FFCC
        0000FFCC3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300CCFF6600FFFF
        9900FFFFCC006666FF0066FF660066FFFF00FF666600FF66FF00FFFF66002100
        A5005F5F5F00777777008686860096969600CBCBCB00B2B2B200D7D7D700DDDD
        DD00E3E3E300EAEAEA00F1F1F100F8F8F800F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00010101010101
        0101010101010101010101010101010101010101010101010101010101100914
        0101010101140910010101011009050914010101140906091001010115091313
        09141514091313091501010101140A131302090213130914010101010101140A
        13131313130A1401010101010101010307121212070301010101010101010103
        070F0F0F07030101010101010101142008080808082014010101010101171C04
        041D1C1D04041C1701010101211A1E1E1A1921191A1E1E1A2101010110161F16
        1701010117161F1A100101010110181701010101011718100101010101010101
        0101010101010101010101010101010101010101010101010101
      }
      OnClick = sbDeleteTemplateClick
    end
    object cbUdp: TCheckBox
      Left = 456
      Height = 21
      Top = 2
      Width = 47
      Caption = 'UDP'
      TabOrder = 3
    end
  end
  object Panel1: TPanel
    Left = 0
    Height = 397
    Top = 169
    Width = 768
    Align = alBottom
    Caption = 'Panel1'
    ClientHeight = 397
    ClientWidth = 768
    TabOrder = 1
    object ToolBar2: TToolBar
      Left = 1
      Height = 30
      Top = 1
      Width = 766
      Caption = 'ToolBar2'
      TabOrder = 0
      object btnClear: TButton
        Left = 691
        Height = 28
        Top = 2
        Width = 75
        Align = alRight
        Caption = 'Clear Log'
        OnClick = btnClearClick
        TabOrder = 0
      end
      object cbLogLevel: TComboBox
        Left = 61
        Height = 23
        Top = 2
        Width = 100
        ItemHeight = 17
        ItemIndex = 0
        Items.Strings = (
          'All'
          'Session'
        )
        Style = csOwnerDrawFixed
        TabOrder = 1
        Text = 'All'
      end
      object cbHex: TCheckBox
        Left = 169
        Height = 21
        Top = 2
        Width = 44
        Caption = 'Hex'
        TabOrder = 2
      end
      object ToolButton2: TToolButton
        Left = 161
        Height = 22
        Top = 2
        Caption = 'ToolButton2'
        Style = tbsSeparator
      end
      object Label3: TLabel
        Left = 1
        Height = 22
        Top = 2
        Width = 60
        AutoSize = False
        Caption = 'Log Level:'
        Layout = tlCenter
        ParentColor = False
      end
      object cbSave: TCheckBox
        Left = 213
        Height = 21
        Top = 2
        Width = 49
        Caption = 'Save'
        OnChange = cbSaveChange
        TabOrder = 3
      end
    end
    object MemoLog: TMemo
      Left = 1
      Height = 365
      Top = 31
      Width = 766
      Align = alClient
      Font.CharSet = ANSI_CHARSET
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Pitch = fpFixed
      Font.Quality = fqDraft
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssAutoBoth
      TabOrder = 1
      WordWrap = False
    end
  end
  object Splitter1: TSplitter
    Cursor = crVSplit
    Left = 0
    Height = 5
    Top = 164
    Width = 768
    Align = alBottom
    ResizeAnchor = akBottom
  end
  object MemoSend: TMemo
    Left = 0
    Height = 138
    Top = 26
    Width = 768
    Align = alClient
    Font.CharSet = ANSI_CHARSET
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Pitch = fpFixed
    Font.Quality = fqDraft
    Lines.Strings = (
      'Put your response message to here.'
    )
    ParentFont = False
    ScrollBars = ssAutoBoth
    TabOrder = 3
  end
  object LTCP1: TLTCPComponent
    Port = 0
    OnReceive = LTCP1Receive
    OnDisconnect = LTCP1Disconnect
    OnAccept = LTCP1Accept
    Timeout = 0
    ReuseAddress = True
    Left = 720
    Top = 208
  end
  object LUDP1: TLUDPComponent
    Port = 0
    OnReceive = LUDP1Receive
    Timeout = 0
    Left = 718
    Top = 264
  end
end
