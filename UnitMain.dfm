object Form1: TForm1
  Left = 218
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Rolling cubes'
  ClientHeight = 321
  ClientWidth = 673
  Color = clWhite
  Constraints.MinHeight = 320
  Constraints.MinWidth = 680
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC8888CCCCCCC0000CCCC00000000CCCC8888CCCCCCCC
    C0000CCCCCCCCCCCCCC8888CCCCC0CCCCC0000CCCCCCCCCCCC8888CCCCC800CC
    C00CCCC0000000000CCCC88CCC88000C0000CCCC00000000CCCC8888C8880000
    00000CCCC000000CCCC888888888C000C00000CCCC0000CCCC88888C888CCC00
    CC00000CCCCCCCCCC88888CC88CCCCC0CCC000CCCCC00CCCCC888CCC8CCCCCCC
    CCCC0CCCCCCCCCCCCCC8CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC8CCC80CCC
    00CCCCCCCC0CC0CCCCCCCC88CC8800CC000CCCCCC000000CCCCCC888CC8800CC
    0000CCCC00000000CCCC8888CC8800CC0000C0CCC000000CCC8C8888CC8800CC
    0000C0CCC000000CCC8C8888CC8800CC0000CCCC00000000CCCC8888CC8800CC
    000CCCCCC000000CCCCCC888CC8800CC00CCCCCCCC0CC0CCCCCCCC88CC880CCC
    0CCCCCCCCCCCCCCCCCCCCCC8CCC8CCCCCCCC0CCCCCCCCCCCCCC8CCCCCCCCCCC0
    CCC000CCCCC00CCCCC888CCC8CCCCC00CC00000CCCCCCCCCC88888CC88CCC000
    C00000CCCC0000CCCC88888C888C000000000CCCC000000CCCC888888888000C
    0000CCCC00000000CCCC8888C88800CCC00CCCC0000000000CCCC88CCC880CCC
    CC0000CCCCCCCCCCCC8888CCCCC8CCCCC0000CCCCCCCCCCCCCC8888CCCCCCCCC
    0000CCCC00000000CCCC8888CCCCCCC0000CCCC0000000000CCCC8888CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Panel3: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 305
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label9: TLabel
      Left = 10
      Top = 15
      Width = 141
      Height = 18
      Caption = 'Size cube in pixels:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 10
      Top = 65
      Width = 119
      Height = 18
      Caption = 'Rotation speed:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 207
      Top = 106
      Width = 33
      Height = 18
      Caption = 'max'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 20
      Top = 106
      Width = 27
      Height = 18
      Caption = 'min'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Shp_Creer: TShape
      Left = 20
      Top = 262
      Width = 218
      Height = 20
      Brush.Color = clSilver
      Pen.Color = clGray
      Shape = stRoundRect
      OnMouseDown = Shp_CreerMouseDown
    end
    object Label13: TLabel
      Left = 75
      Top = 263
      Width = 103
      Height = 18
      Caption = 'Create cube '
      Color = clSilver
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      OnMouseDown = Shp_CreerMouseDown
    end
    object Edt_Taille: TEdit
      Left = 187
      Top = 15
      Width = 31
      Height = 21
      TabStop = False
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = '150'
    end
    object UpDown2: TUpDown
      Left = 218
      Top = 15
      Width = 18
      Height = 21
      Associate = Edt_Taille
      Min = 50
      Max = 250
      Increment = 5
      Position = 150
      TabOrder = 1
    end
    object Tkb_Vitesse: TTrackBar
      Left = 10
      Top = 84
      Width = 237
      Height = 21
      Max = 50
      Position = 25
      TabOrder = 2
      ThumbLength = 16
      TickStyle = tsNone
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 153
      Width = 222
      Height = 88
      Caption = ' Cube type  '
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object Rbt_Virtuel: TRadioButton
        Left = 49
        Top = 24
        Width = 70
        Height = 25
        Caption = 'virtual'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = True
      end
      object Rbt_Reel: TRadioButton
        Left = 49
        Top = 55
        Width = 51
        Height = 21
        Caption = 'real'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
end
