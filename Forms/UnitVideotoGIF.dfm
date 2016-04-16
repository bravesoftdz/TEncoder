object VideoToGIFForm: TVideoToGIFForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Video to GIF'
  ClientHeight = 270
  ClientWidth = 784
  Color = 16708071
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    784
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object SourceEdit: TsFilenameEdit
    Left = 64
    Top = 8
    Width = 712
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    TabOrder = 0
    Text = ''
    CheckOnExit = True
    BoundLabel.Active = True
    BoundLabel.Caption = 'Source:'
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Blend = 0
    GlyphMode.Grayed = False
    OnAfterDialog = SourceEditAfterDialog
  end
  object DestEdit: TsFilenameEdit
    Left = 64
    Top = 35
    Width = 712
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    TabOrder = 1
    Text = ''
    CheckOnExit = True
    BoundLabel.Active = True
    BoundLabel.Caption = 'Destination:'
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Blend = 0
    GlyphMode.Grayed = False
    Filter = 'GIF|*.gif'
  end
  object WidthEdit: TsSpinEdit
    Left = 64
    Top = 62
    Width = 75
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 2
    Text = '320'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Width:'
    MaxValue = 0
    MinValue = 0
    Value = 320
  end
  object HeightEdit: TsSpinEdit
    Left = 184
    Top = 62
    Width = 75
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 3
    Text = '240'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Height:'
    MaxValue = 0
    MinValue = 0
    Value = 240
  end
  object KeepAspectBtn: TsCheckBox
    Left = 265
    Top = 62
    Width = 110
    Height = 19
    Caption = 'Keep aspect ratio'
    TabOrder = 4
    OnClick = KeepAspectBtnClick
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object DelayEdit: TsSpinEdit
    Left = 701
    Top = 62
    Width = 75
    Height = 21
    Alignment = taCenter
    Anchors = [akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 5
    Text = '20'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Delay between GIF frames (ms):'
    MaxValue = 0
    MinValue = 0
    Value = 20
  end
  object StartBar: TsTrackBar
    Left = 145
    Top = 116
    Width = 631
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    ShowSelRange = False
    TabOrder = 6
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = StartBarChange
    SkinData.SkinSection = 'TRACKBAR'
    BarOffsetV = 0
    BarOffsetH = 0
  end
  object EndBar: TsTrackBar
    Left = 145
    Top = 147
    Width = 631
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    ShowSelRange = False
    TabOrder = 7
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = EndBarChange
    SkinData.SkinSection = 'TRACKBAR'
    BarOffsetV = 0
    BarOffsetH = 0
  end
  object StartEdit: TsEdit
    Left = 64
    Top = 118
    Width = 75
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    Text = '00:00:00.000'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Start:'
  end
  object EndEdit: TsEdit
    Left = 64
    Top = 149
    Width = 75
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    Text = '00:00:00.000'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'End:'
  end
  object StartBtn: TsButton
    Left = 676
    Top = 232
    Width = 100
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    TabOrder = 10
    OnClick = StartBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object StopBtn: TsButton
    Left = 570
    Top = 232
    Width = 100
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 11
    OnClick = StopBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object ResetBtn: TsButton
    Left = 8
    Top = 232
    Width = 100
    Height = 30
    Anchors = [akLeft, akBottom]
    Caption = 'Reset'
    TabOrder = 12
    SkinData.SkinSection = 'BUTTON'
  end
  object DurationEdit: TsEdit
    Left = 701
    Top = 178
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 13
    Text = '00:00:00.000'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Duration of selected part:'
  end
  object ConsoleEdit: TsEdit
    Left = 8
    Top = 205
    Width = 768
    Height = 21
    Alignment = taCenter
    Anchors = [akLeft, akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 14
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Caption = 'FFMpeg:'
  end
  object InfoEdit: TsEdit
    Left = 362
    Top = 237
    Width = 206
    Height = 21
    Alignment = taCenter
    Anchors = [akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 15
    SkinData.SkinSection = 'EDIT'
  end
  object ProgressBar1: TsProgressBar
    Left = 114
    Top = 232
    Width = 242
    Height = 30
    Anchors = [akLeft, akRight, akBottom]
    DoubleBuffered = False
    ParentDoubleBuffered = False
    Smooth = True
    Style = pbstMarquee
    MarqueeInterval = 50
    TabOrder = 16
    Visible = False
    SkinData.SkinSection = 'GAUGE'
  end
  object MemoryEdit: TsSpinEdit
    Left = 145
    Top = 89
    Width = 114
    Height = 21
    Alignment = taCenter
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 17
    Text = '512'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Max Memory Usage (MB):'
    MaxValue = 0
    MinValue = 0
    Value = 512
  end
  object FPSEdit: TsSpinEdit
    Left = 701
    Top = 89
    Width = 75
    Height = 21
    Alignment = taCenter
    Anchors = [akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 18
    Text = '5'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Number of frames per second to be extracted from video:'
    MaxValue = 0
    MinValue = 0
    Value = 5
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    FormHeader.AdditionalHeight = 0
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 336
    Top = 8
  end
  object PosTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PosTimerTimer
    Left = 408
    Top = 8
  end
end
