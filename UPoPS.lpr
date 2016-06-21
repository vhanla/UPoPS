program UPoPS;

uses
  Forms, Interfaces,
  main in 'main.pas' {Form1},
  verificador in 'verificador.pas',
  MultiMonitor in 'MultiMonitor.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
