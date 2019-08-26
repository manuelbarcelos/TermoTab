% C�digo: Consulta a Tabelas Propriedades Termodin�micas 
% Respons�vel: Manuel Nascimento Dias Barcelos J�nior (professor)
% e-mail: manuelbarcelos@aerospace.unb.br
%         manuelbarcelos@unb.br
% C�digo: TermoTab0.6
% Data: 23/08/2019

clc;
clear all;
close all;
format long;

% Gloss�rio
% T:temperatura; 
% P:press�o; 
% v:volume espec�fico;
% u:energia interna espec�fica; 
% h:entalpia espec�fica; 
% s:entropia espec�fica; 
% l:liquido; 
% v:vapor; 
% 0:refer�ncia; 
% r:relativo;

% Defini��o do tipo de fluido de trabalho (Subst�ncia Pura ou G�s Ideal)
disp('Defini��o do fluido de trabalho:')
disp('1 para H2O')
disp('2 para R134a')
disp('3 para Ar')
FldTrab = input('Entre o n�mero:');
clc;
if FldTrab==1
    TipTab=' H2O ';
elseif FldTrab==2
    TipTab='R134a';
elseif FldTrab==3
    TipTab=' AR  ';
end

disp('--------------------------------------------------------------------------')

if TipTab==' H2O ' | TipTab=='R134a'
% Entrada das propriedades que caracterizam o estado da Subst�ncia Pura
% T[oC]; P[kPa]; v[m3/kg]; u[kJ/kg]; h[kJ/kg]; s[kJ/kgK]; 
% Escolher duas propriedades intensivas e independentes para definir o
% estado (apenas a estas atribuir um valor num�rico), ou uma propriedade 
% intensiva e o t�tulo, deixando as outras iguais a zero, e no caso do
% t�tulo igual a -1.
% T=0; P=0; v=0; u=0; h=0; s=0; x=-1; 
   T=0; P=0; v=0; u=0; h=0; s=0; x=-1;
   disp('N�meros identificadores das propriedades:')
   disp('1 para Temperatura, T, em [oC]')
   disp('2 para Press�o, P, em [kPa]')
   disp('3 para Volume espec�fico, v, em [m3/kg]')
   disp('4 para Energia interna espec�fica, u, em [kJ/kg]')
   disp('5 para Entalpia espec�fica, h, em [kJ/kg]')
   disp('6 para Entropia espec�fica, s, em [kJ/kgK]')
   disp('7 para T�tulo, x, em [m3/kg]')
   disp('Primeira propriedade:')
   PropId1 = input('Entre o n�mero identificador:');
   Prop1 = input('Entre o valor da propriedade:');
   disp('Segunda propriedade:')
   PropId2 = input('Entre o n�mero identificador:');
   Prop2 = input('Entre o valor da primeira propriedade:');
   clc;   
   if PropId1==1
       T=Prop1;
   elseif PropId1==2
       P=Prop1;
   elseif PropId1==3
       v=Prop1;
   elseif PropId1==4
       u=Prop1;
   elseif PropId1==5
       h=Prop1;
   elseif PropId1==6
       s=Prop1;
   elseif PropId1==7
       x=Prop1;
   else
       disp('Escolha errada da propriedade 1!')
       TipTab='';
   end
   if PropId2==1
       T=Prop2;
   elseif PropId2==2
       P=Prop2;
   elseif PropId2==3
       v=Prop2;
   elseif PropId2==4
       u=Prop2;
   elseif PropId2==5
       h=Prop2;
   elseif PropId2==6
       s=Prop2;
   elseif PropId2==7
       x=Prop2;
   else
       disp('Escolha errada da propriedade 2!')
       TipTab='';
   end
   VetPropSubPurEnt=[T P v u h s x];
   VetPropSubPurSai=zeros(1,15);
   
elseif TipTab==' AR  '
% Entrada das propriedades que caracterizam o estado do G�s Ideal
% T[K]; u[kJ/kg]; h[kJ/kg]; s0[kJ/kgK]; 
% Escolher umas das entradas e apenas a esta atribuir um valor num�rico, 
% uma vez que estas dependem s� da temperatura g�s ideal, deixando a outras
% iguais a zero. 
% T=0; u=0; h=0; s0=0; vr=0; Pr=0;
   T=0; u=0; h=0; s0=0; vr=0; Pr=0;
   disp('N�meros identificadores das entradas:')
   disp('1 para Temperatura, T, em [K]')
   disp('2 para Energia interna espec�fica, u, em [kJ/kg]')
   disp('3 para Entalpia espec�fica, h, em [kJ/kg]')
   disp('4 para Entropia espec�fica, s0, em [kJ/kgK]')
   disp('5 para Volume relativo, vr')
   disp('6 para Press�o relativa, Pr')
   PropId1 = input('Entre o n�mero identificador:');
   Prop1 = input('Entre o valor da entrada:');
   clc;   
   if PropId1==1
       T=Prop1;
   elseif PropId1==2
       u=Prop1;
   elseif PropId1==3
       h=Prop1;
   elseif PropId1==4
       s0=Prop1;
   elseif PropId1==5
       vr=Prop1;
   elseif PropId1==6
       Pr=Prop1;
   else
       disp('Escolha errada da entrada!')
       TipTab='';
   end
   VetPropGasIdEnt=[T u h s0 vr Pr];
   VetPropGasIdSai=zeros(1,6);

end

if TipTab==' H2O ' | TipTab=='R134a'
% Chamada da fun��o de c�lculo de propriedades
    [VetPropSubPurSai,Reg]=TermoTab(TipTab,VetPropSubPurEnt);
    
% Sa�da das propriedades que caracterizam o estado da Subst�ncia Pura
    T=VetPropSubPurSai(1); P=VetPropSubPurSai(2); v=VetPropSubPurSai(3); 
    u=VetPropSubPurSai(4); h=VetPropSubPurSai(5); s=VetPropSubPurSai(6); 
    x=VetPropSubPurSai(7); vl=VetPropSubPurSai(8); vv=VetPropSubPurSai(9); 
    ul=VetPropSubPurSai(10); uv=VetPropSubPurSai(11); hl=VetPropSubPurSai(12); 
    hv=VetPropSubPurSai(13); sl=VetPropSubPurSai(14); sv=VetPropSubPurSai(15);
    disp('Temperatura [oC]')
    disp(T)
    disp('Press�o [kPa]')
    disp(P)
    disp('Volume espec�fico [m3/kg]')
    disp(v)
    disp('Energia interna espec�fica [kJ/kg]')
    disp(u)
    disp('Entalpia espec�fica [kJ/kg]')
    disp(h)
    disp('Entropia espec�fica [kJ/kgK]')
    disp(s)
    if Reg=='MLV'
        disp('T�tulo')
        disp(x)
        disp('Volume espec�fico de l�quido saturado [m3/kg]')
        disp(vl)
        disp('Volume espec�fico de vapor saturado [m3/kg]')
        disp(vv)
        disp('Energia interna espec�fica de l�quido saturado [kJ/kg]')
        disp(ul)
        disp('Energia interna espec�fica de vapor saturado [kJ/kg]')
        disp(uv)
        disp('Entalpia espec�fica de l�quido saturado [kJ/kg]')
        disp(hl)
        disp('Entalpia espec�fica de vapor saturado [kJ/kg]')
        disp(hv)
        disp('Entropia espec�fica de l�quido saturado [kJ/kgK]')
        disp(sl)
        disp('Entropia espec�fica de vapor saturado [kJ/kgK]')
        disp(sv)
    end
elseif TipTab==' AR  '
% Chamada da fun��o de c�lculo de propriedades
    [VetPropGasIdSai,Reg]=TermoTab(TipTab,VetPropGasIdEnt);
    
% Sa�da das propriedades que caracterizam o estado do G�s Ideal
    T=VetPropGasIdSai(1); u=VetPropGasIdSai(2); h=VetPropGasIdSai(3);
    s0=VetPropGasIdSai(4); vr=VetPropGasIdSai(5); Pr=VetPropGasIdSai(6);
    disp('Temperatura [K]')
    disp(T)
    disp('Energia interna espec�fica [kJ/kg]')
    disp(u)
    disp('Entalpia espec�fica [kJ/kg]')
    disp(h)
    disp('Integral de "cp(T)/T" de T0 a T [kJ/kgK]')
    disp(s0)
    disp('Volume espec�fico relativo')
    disp(vr)
    disp('Press�o relativa')
    disp(Pr)
end
