object TournamentFrm: TTournamentFrm
  Left = 477
  Height = 348
  Top = 228
  Width = 405
  Caption = 'Параметры соревнования'
  ClientHeight = 348
  ClientWidth = 405
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '1.8.4.0'
  object Panel1: TPanel
    Left = 0
    Height = 50
    Top = 298
    Width = 405
    Align = alBottom
    BorderStyle = bsSingle
    ClientHeight = 46
    ClientWidth = 401
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 232
      Height = 30
      Top = 6
      Width = 75
      Cancel = True
      DefaultCaption = True
      Kind = bkCancel
      ModalResult = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 144
      Height = 30
      Top = 6
      Width = 75
      Default = True
      DefaultCaption = True
      Kind = bkOK
      ModalResult = 1
      TabOrder = 1
    end
  end
  object Label1: TLabel
    Left = 8
    Height = 13
    Top = 11
    Width = 192
    AutoSize = False
    Caption = 'Дата соревнования'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Height = 13
    Top = 72
    Width = 165
    AutoSize = False
    Caption = 'Название соревнования'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 9
    Height = 13
    Top = 120
    Width = 167
    AutoSize = False
    Caption = 'Место проведения'
    ParentColor = False
  end
  object Label4: TLabel
    Left = 9
    Height = 13
    Top = 168
    Width = 199
    AutoSize = False
    Caption = 'Главный судья'
    ParentColor = False
  end
  object Label5: TLabel
    Left = 9
    Height = 13
    Top = 232
    Width = 231
    AutoSize = False
    Caption = 'Секретарь судейской бригады'
    ParentColor = False
  end
  object TourDate: TDateTimePicker
    Left = 9
    Height = 21
    Top = 32
    Width = 111
    CenturyFrom = 1941
    MaxDate = 2958465
    MinDate = 36526
    AutoSize = False
    TabOrder = 1
    TrailingSeparator = False
    TextForNullDate = '---'
    LeadingZeros = True
    Kind = dtkDate
    TimeFormat = tf24
    TimeDisplay = tdHMS
    DateMode = dmComboBox
    Date = 43305
    Time = 0.386992893516435
    UseDefaultSeparators = True
    HideDateTimeParts = []
    MonthNames = 'Long'
  end
  object TourNameEdit: TEdit
    Left = 8
    Height = 21
    Top = 88
    Width = 320
    TabOrder = 2
    Text = 'TourNameEdit'
  end
  object TourPlaceEdit: TEdit
    Left = 9
    Height = 21
    Top = 136
    Width = 303
    TabOrder = 3
    Text = 'TourPlaceEdit'
  end
  object RefereeEdit: TEdit
    Left = 9
    Height = 21
    Top = 191
    Width = 328
    TabOrder = 4
    Text = 'RefereeEdit'
  end
  object AssistantEdit: TEdit
    Left = 8
    Height = 21
    Top = 258
    Width = 320
    TabOrder = 5
    Text = 'AssistantEdit'
  end
  object TourDate2: TDateTimePicker
    Left = 160
    Height = 21
    Top = 32
    Width = 111
    CenturyFrom = 1941
    MaxDate = 2958465
    MinDate = 36526
    AutoSize = False
    TabOrder = 6
    TrailingSeparator = False
    TextForNullDate = '---'
    LeadingZeros = True
    Kind = dtkDate
    TimeFormat = tf24
    TimeDisplay = tdHMS
    DateMode = dmComboBox
    Date = 43305
    Time = 0.386992893516435
    UseDefaultSeparators = True
    HideDateTimeParts = []
    MonthNames = 'Long'
  end
  object Label6: TLabel
    Left = 130
    Height = 13
    Top = 38
    Width = 24
    AutoSize = False
    Caption = 'по'
    ParentColor = False
  end
end
