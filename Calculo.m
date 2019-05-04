% Código: Consulta a Tabelas Propriedades Termodinâmicas 
% Responsável: Manuel Nascimento Dias Barcelos Júnior (professor)
% e-mail: manuelbarcelos@aerospace.unb.br
%         manuelbarcelos@unb.br
% Código: TermoTab0.5
% Data: 05/05/2019

clc;
clear all;
close all;
format long;

% Glossário
% T:temperatura; 
% P:pressão; 
% v:volume específico;
% u:energia interna específica; 
% h:entalpia específica; 
% s:entropia específica; 
% l:liquido; 
% v:vapor; 
% 0:referência; 
% r:relativo;

% Definição do tipo de fluido de trabalho (Substância Pura ou Gás Ideal)
%TipTab=' H2O ';
TipTab='R134a';
%TipTab=' AR  ';

% Entrada das propriedades que caracterizam o estado da Substância Pura
% T[oC]; P[kPa]; v[m3/kg]; u[kJ/kg]; h[kJ/kg]; s[kJ/kgK]; 
% Escolher duas propriedades intensivas e independentes para definir o
% estado (apenas a estas atribuir um valor numérico), ou uma propriedade 
% intensiva e o título, deixando as outras iguais a zero, e no caso do
% título igual a -1.
% T=0; P=0; v=0; u=0; h=0; s=0; x=-1; 
T=0; P=0; v=0; u=0; h=0; s=0; x=-1; 
VetPropSubPurEnt=[T P v u h s x];
VetPropSubPurSai=zeros(1,15);

% Entrada das propriedades que caracterizam o estado do Gás Ideal
% T[K]; u[kJ/kg]; h[kJ/kg]; s0[kJ/kgK]; 
% Escolher umas das entradas e apenas a esta atribuir um valor numérico, 
% uma vez que estas dependem só da temperatura gás ideal, deixando a outras
% iguais a zero. 
% T=0; u=0; h=0; s0=0; vr=0; Pr=0;
T=0; u=0; h=0; s0=0; vr=0; Pr=0;
VetPropGasIdEnt=[T u h s0 vr Pr];
VetPropGasIdSai=zeros(1,6);

% Chamada da função de cálculo de propriedades
[VetPropSubPurSai,VetPropGasIdSai,Reg]=TermoTab(TipTab,VetPropSubPurEnt,VetPropGasIdEnt);

disp('--------------------------------------------------------------------------')

if TipTab==' H2O ' | TipTab=='R134a'
% Saída das propriedades que caracterizam o estado da Substância Pura
    T=VetPropSubPurSai(1); P=VetPropSubPurSai(2); v=VetPropSubPurSai(3); 
    u=VetPropSubPurSai(4); h=VetPropSubPurSai(5); s=VetPropSubPurSai(6); 
    x=VetPropSubPurSai(7); vl=VetPropSubPurSai(8); vv=VetPropSubPurSai(9); 
    ul=VetPropSubPurSai(10); uv=VetPropSubPurSai(11); hl=VetPropSubPurSai(12); 
    hv=VetPropSubPurSai(13); sl=VetPropSubPurSai(14); sv=VetPropSubPurSai(15);
    disp('Temperatura [oC]')
    disp(T)
    disp('Pressão [kPa]')
    disp(P)
    disp('Volume específico [m3/kg]')
    disp(v)
    disp('Energia interna específica [kJ/kg]')
    disp(u)
    disp('Entalpia específica [kJ/kg]')
    disp(h)
    disp('Entropia específica [kJ/kgK]')
    disp(s)
    if Reg=='MLV'
        disp('Título')
        disp(x)
        disp('Volume específico de líquido saturado [m3/kg]')
        disp(vl)
        disp('Volume específico de vapor saturado [m3/kg]')
        disp(vv)
        disp('Energia interna específica de líquido saturado [kJ/kg]')
        disp(ul)
        disp('Energia interna específica de vapor saturado [kJ/kg]')
        disp(uv)
        disp('Entalpia específica de líquido saturado [kJ/kg]')
        disp(hl)
        disp('Entalpia específica de vapor saturado [kJ/kg]')
        disp(hv)
        disp('Entropia específica de líquido saturado [kJ/kgK]')
        disp(sl)
        disp('Entropia específica de vapor saturado [kJ/kgK]')
        disp(sv)
    end
elseif TipTab==' AR  '
% Saída das propriedades que caracterizam o estado do Gás Ideal
    T=VetPropGasIdSai(1); u=VetPropGasIdSai(2); h=VetPropGasIdSai(3);
    s0=VetPropGasIdSai(4); vr=VetPropGasIdSai(5); Pr=VetPropGasIdSai(6);
    disp('Temperatura [K]')
    disp(T)
    disp('Energia interna específica [kJ/kg]')
    disp(u)
    disp('Entalpia específica [kJ/kg]')
    disp(h)
    disp('Integral de "cp(T)/T" de T0 a T [kJ/kgK]')
    disp(s0)
    disp('Volume específico relativo')
    disp(vr)
    disp('Pressão relativa')
    disp(Pr)
end
