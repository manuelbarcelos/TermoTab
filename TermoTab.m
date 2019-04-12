% Autor: Manuel Nascimento Dias Barcelos Júnior (professor)
% e-mail: manuelbarcelos@aerospace.unb.br
%         manuelbarcelos@unb.br
% Código: TermoTab0.3

function [VetPropSubPurSai,VetPropGasIdSai,Reg]=TermoTab(TipTab,VetPropSubPurEnt,VetPropGasIdEnt)

    VetPropSubPurSai=zeros(1,15);
    VetPropGasIdSai=zeros(1,6);
    Reg='   ';
    ErrCarrTab=0;
    
    contPropSP=0;
    if VetPropSubPurEnt(1)~=0
        contPropSP=contPropSP+1;
    elseif VetPropSubPurEnt(2)~=0
        contPropSP=contPropSP+1;
    elseif VetPropSubPurEnt(3)~=0
        contPropSP=contPropSP+1;
    elseif VetPropSubPurEnt(4)~=0
        contPropSP=contPropSP+1;
    elseif VetPropSubPurEnt(5)~=0
        contPropSP=contPropSP+1;
    elseif VetPropSubPurEnt(6)~=0
        contPropSP=contPropSP+1;
    elseif VetPropSubPurEnt(7)~=NaN
        contPropSP=contPropSP+1;
    end
        
    contPropGI=0;
    if VetPropGasIdEnt(1)~=0
        contPropGI=contPropGI+1;
    elseif VetPropGasIdEnt(2)~=0
        contPropGI=contPropGI+1;
    elseif VetPropGasIdEnt(3)~=0
        contPropGI=contPropGI+1;
    elseif VetPropGasIdEnt(4)~=0
        contPropGI=contPropGI+1;
    elseif VetPropGasIdEnt(5)~=0
        contPropGI=contPropGI+1;
    elseif VetPropGasIdEnt(6)~=0
        contPropGI=contPropGI+1;
    end
    
% Carregar tabelas do fluido de trabalho
    if TipTab==' H2O '
        disp('As tabelas das propriedades da água foram carregadas!')
        [Pvsa, TabPvsa, nPvsa, TabPlvs, TabTlvs, TabArGI]=Tabelas(TipTab);
        Pvsa=1000*Pvsa;
        n=nPvsa;
    elseif TipTab=='R134a'
        disp('As tabelas das propriedades do R134a foram carregadas!')
        [Pvsa, TabPvsa, nPvsa, TabPlvs, TabTlvs, TabArGI]=Tabelas(TipTab);
        Pvsa=1000*Pvsa;
        n=nPvsa;
    elseif TipTab==' AR  '
        disp('As tabelas das propriedades do ar foram carregadas!')
        [Pvsa, TabPvsa, nPvsa, TabPlvs, TabTlvs, TabArGI]=Tabelas(TipTab);
    else
        disp('Não foram carregadas tabelas de propriedades do fluido de trabalho!!!!!')
        ErrCarrTab=1;
    end
    
    if ErrCarrTab == 0
        
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
        if (TipTab==' H2O ' | TipTab=='R134a') & (contPropSP<=2)
            T=VetPropSubPurEnt(1); P=VetPropSubPurEnt(2); v=VetPropSubPurEnt(3); 
            u=VetPropSubPurEnt(4); h=VetPropSubPurEnt(5); s=VetPropSubPurEnt(6); 
            x=VetPropSubPurEnt(7); vl=0; vv=0; ul=0; uv=0; hl=0; hv=0; sl=0; sv=0;
%--------------------------------------------------------------------------
            if (P~=0 & v~=0) & (T==0 & u==0 & h==0 & s==0)
                i=find(TabPlvs(:,1)>=P,1);
                if i>0
                    vlr=interp1(TabPlvs(:,1),TabPlvs(:,3),P);
                    vvr=interp1(TabPlvs(:,1),TabPlvs(:,4),P);
                    if v>=vlr & v<=vvr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabPlvs(:,1),TabPlvs(:,2),P);
                        vl=interp1(TabPlvs(:,1),TabPlvs(:,3),P);
                        vv=interp1(TabPlvs(:,1),TabPlvs(:,4),P);
                        ul=interp1(TabPlvs(:,1),TabPlvs(:,5),P);
                        uv=interp1(TabPlvs(:,1),TabPlvs(:,7),P);
                        hl=interp1(TabPlvs(:,1),TabPlvs(:,8),P);
                        hv=interp1(TabPlvs(:,1),TabPlvs(:,10),P);
                        sl=interp1(TabPlvs(:,1),TabPlvs(:,11),P);
                        sv=interp1(TabPlvs(:,1),TabPlvs(:,13),P);
                        x=(v-vl)/(vv-vl);
                        u=ul+x*(uv-ul);
                        h=hl+x*(hv-hl);
                        s=sl+x*(sv-sl);
                    elseif v<vlr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif v>vvr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        j=find(Pvsa(:)==P,1);
                        if j>0
                            T=interp1(TabPvsa(1:n(j),2,j),TabPvsa(1:n(j),1,j),v);
                            u=interp1(TabPvsa(1:n(j),2,j),TabPvsa(1:n(j),3,j),v);
                            h=interp1(TabPvsa(1:n(j),2,j),TabPvsa(1:n(j),4,j),v);
                            s=interp1(TabPvsa(1:n(j),2,j),TabPvsa(1:n(j),5,j),v);
                        else
                            k=find(Pvsa(:)>P,1);
                            if k>0
                                Tk(1)=interp1(TabPvsa(1:n(k-1),2,k-1),TabPvsa(1:n(k-1),1,k-1),v);
                                uk(1)=interp1(TabPvsa(1:n(k-1),2,k-1),TabPvsa(1:n(k-1),3,k-1),v);
                                hk(1)=interp1(TabPvsa(1:n(k-1),2,k-1),TabPvsa(1:n(k-1),4,k-1),v);
                                sk(1)=interp1(TabPvsa(1:n(k-1),2,k-1),TabPvsa(1:n(k-1),5,k-1),v);
                                Tk(2)=interp1(TabPvsa(1:n(k),2,k),TabPvsa(1:n(k),1,k),v);
                                uk(2)=interp1(TabPvsa(1:n(k),2,k),TabPvsa(1:n(k),3,k),v);
                                hk(2)=interp1(TabPvsa(1:n(k),2,k),TabPvsa(1:n(k),4,k),v);
                                sk(2)=interp1(TabPvsa(1:n(k),2,k),TabPvsa(1:n(k),5,k),v);
                                Pk=[Pvsa(k-1) Pvsa(k)];
                                T=interp1(Pk,Tk,P);
                                u=interp1(Pk,uk,P);
                                h=interp1(Pk,hk,P);
                                s=interp1(Pk,sk,P);
                            end
                        end
                    end
                elseif P < TabPlvs(1,1) | P > TabPlvs(end,1)
                    disp('Valor de pressão informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif (P~=0 & u~=0) & (T==0 & v==0 & h==0 & s==0)
                i=find(TabPlvs(:,1)>=P,1);
                if i>0
                    ulr=interp1(TabPlvs(:,1),TabPlvs(:,5),P);
                    uvr=interp1(TabPlvs(:,1),TabPlvs(:,7),P);
                    if u>=ulr & u<=uvr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabPlvs(:,1),TabPlvs(:,2),P);
                        vl=interp1(TabPlvs(:,1),TabPlvs(:,3),P);
                        vv=interp1(TabPlvs(:,1),TabPlvs(:,4),P);
                        ul=interp1(TabPlvs(:,1),TabPlvs(:,5),P);
                        uv=interp1(TabPlvs(:,1),TabPlvs(:,7),P);
                        hl=interp1(TabPlvs(:,1),TabPlvs(:,8),P);
                        hv=interp1(TabPlvs(:,1),TabPlvs(:,10),P);
                        sl=interp1(TabPlvs(:,1),TabPlvs(:,11),P);
                        sv=interp1(TabPlvs(:,1),TabPlvs(:,13),P);
                        x=(u-ul)/(uv-ul);
                        v=vl+x*(vv-vl);
                        h=hl+x*(hv-hl);
                        s=sl+x*(sv-sl);
                    elseif u<ulr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif u>uvr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        j=find(Pvsa(:)==P,1);
                        if j>0
                            T=interp1(TabPvsa(1:n(j),3,j),TabPvsa(1:n(j),1,j),u);
                            v=interp1(TabPvsa(1:n(j),3,j),TabPvsa(1:n(j),2,j),u);
                            h=interp1(TabPvsa(1:n(j),3,j),TabPvsa(1:n(j),4,j),u);
                            s=interp1(TabPvsa(1:n(j),3,j),TabPvsa(1:n(j),5,j),u);
                        else
                            k=find(Pvsa(:)>P,1);
                            if k>0
                                Tk(1)=interp1(TabPvsa(1:n(k-1),3,k-1),TabPvsa(1:n(k-1),1,k-1),u);
                                vk(1)=interp1(TabPvsa(1:n(k-1),3,k-1),TabPvsa(1:n(k-1),2,k-1),u);
                                hk(1)=interp1(TabPvsa(1:n(k-1),3,k-1),TabPvsa(1:n(k-1),4,k-1),u);
                                sk(1)=interp1(TabPvsa(1:n(k-1),3,k-1),TabPvsa(1:n(k-1),5,k-1),u);
                                Tk(2)=interp1(TabPvsa(1:n(k),3,k),TabPvsa(1:n(k),1,k),u);
                                vk(2)=interp1(TabPvsa(1:n(k),3,k),TabPvsa(1:n(k),2,k),u);
                                hk(2)=interp1(TabPvsa(1:n(k),3,k),TabPvsa(1:n(k),4,k),u);
                                sk(2)=interp1(TabPvsa(1:n(k),3,k),TabPvsa(1:n(k),5,k),u);
                                Pk=[Pvsa(k-1) Pvsa(k)];
                                T=interp1(Pk,Tk,P);
                                v=interp1(Pk,vk,P);
                                h=interp1(Pk,hk,P);
                                s=interp1(Pk,sk,P);
                            end
                        end
                    end
                elseif P < TabPlvs(1,1) | P > TabPlvs(end,1)
                    disp('Valor de pressão informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif (P~=0 & h~=0) & (T==0 & u==0 & v==0 & s==0)
                i=find(TabPlvs(:,1)>=P,1);
                if i>0
                    hlr=interp1(TabPlvs(:,1),TabTlvs(:,8),P);
                    hvr=interp1(TabPlvs(:,1),TabTlvs(:,10),P);
                    if h>=hlr & h<=hvr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabPlvs(:,1),TabPlvs(:,2),P);
                        vl=interp1(TabPlvs(:,1),TabPlvs(:,3),P);
                        vv=interp1(TabPlvs(:,1),TabPlvs(:,4),P);
                        ul=interp1(TabPlvs(:,1),TabPlvs(:,5),P);
                        uv=interp1(TabPlvs(:,1),TabPlvs(:,7),P);
                        hl=interp1(TabPlvs(:,1),TabPlvs(:,8),P);
                        hv=interp1(TabPlvs(:,1),TabPlvs(:,10),P);
                        sl=interp1(TabPlvs(:,1),TabPlvs(:,11),P);
                        sv=interp1(TabPlvs(:,1),TabPlvs(:,13),P);
                        x=(h-hl)/(hv-hl);
                        u=ul+x*(uv-ul);
                        v=vl+x*(vv-vl);
                        s=sl+x*(sv-sl);
                    elseif h<hlr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif h>hvr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        j=find(Pvsa(:)==P,1);
                        if j>0
                            T=interp1(TabPvsa(1:n(j),4,j),TabPvsa(1:n(j),1,j),h);
                            u=interp1(TabPvsa(1:n(j),4,j),TabPvsa(1:n(j),3,j),h);
                            v=interp1(TabPvsa(1:n(j),4,j),TabPvsa(1:n(j),2,j),h);
                            s=interp1(TabPvsa(1:n(j),4,j),TabPvsa(1:n(j),5,j),h);
                        else
                            k=find(Pvsa(:)>P,1);
                            if k>0
                                Tk(1)=interp1(TabPvsa(1:n(k-1),4,k-1),TabPvsa(1:n(k-1),1,k-1),v);
                                uk(1)=interp1(TabPvsa(1:n(k-1),4,k-1),TabPvsa(1:n(k-1),3,k-1),v);
                                vk(1)=interp1(TabPvsa(1:n(k-1),4,k-1),TabPvsa(1:n(k-1),2,k-1),v);
                                sk(1)=interp1(TabPvsa(1:n(k-1),4,k-1),TabPvsa(1:n(k-1),5,k-1),v);
                                Tk(2)=interp1(TabPvsa(1:n(k),4,k),TabPvsa(1:n(k),1,k),v);
                                uk(2)=interp1(TabPvsa(1:n(k),4,k),TabPvsa(1:n(k),3,k),v);
                                vk(2)=interp1(TabPvsa(1:n(k),4,k),TabPvsa(1:n(k),2,k),v);
                                sk(2)=interp1(TabPvsa(1:n(k),4,k),TabPvsa(1:n(k),5,k),v);
                                Pk=[Pvsa(k-1) Pvsa(k)];
                                T=interp1(Pk,Tk,P);
                                u=interp1(Pk,uk,P);
                                v=interp1(Pk,vk,P);
                                s=interp1(Pk,sk,P);
                            end
                        end
                    end
                elseif P < TabPlvs(1,1) | P > TabPlvs(end,1)
                    disp('Valor de pressão informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif (P~=0 & s~=0) & (T==0 & u==0 & h==0 & v==0)
                i=find(TabPlvs(:,1)>=P,1);
                if i>0
                    slr=interp1(TabPlvs(:,1),TabPlvs(:,11),P);
                    svr=interp1(TabPlvs(:,1),TabPlvs(:,13),P);
                    if s>=slr & s<=svr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabPlvs(:,1),TabPlvs(:,2),P);
                        vl=interp1(TabPlvs(:,1),TabPlvs(:,3),P);
                        vv=interp1(TabPlvs(:,1),TabPlvs(:,4),P);
                        ul=interp1(TabPlvs(:,1),TabPlvs(:,5),P);
                        uv=interp1(TabPlvs(:,1),TabPlvs(:,7),P);
                        hl=interp1(TabPlvs(:,1),TabPlvs(:,8),P);
                        hv=interp1(TabPlvs(:,1),TabPlvs(:,10),P);
                        sl=interp1(TabPlvs(:,1),TabPlvs(:,11),P);
                        sv=interp1(TabPlvs(:,1),TabPlvs(:,13),P);
                        x=(s-sl)/(sv-sl);
                        u=ul+x*(uv-ul);
                        h=hl+x*(hv-hl);
                        v=vl+x*(vv-vl);
                    elseif s<slr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif s>svr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        j=find(Pvsa(:)==P,1);
                        if j>0
                            T=interp1(TabPvsa(1:n(j),5,j),TabPvsa(1:n(j),1,j),s);
                            u=interp1(TabPvsa(1:n(j),5,j),TabPvsa(1:n(j),3,j),s);
                            h=interp1(TabPvsa(1:n(j),5,j),TabPvsa(1:n(j),4,j),s);
                            v=interp1(TabPvsa(1:n(j),5,j),TabPvsa(1:n(j),2,j),s);
                        else
                            k=find(Pvsa(:)>P,1);
                            if k>0
                                Tk(1)=interp1(TabPvsa(1:n(k-1),5,k-1),TabPvsa(1:n(k-1),1,k-1),s);
                                uk(1)=interp1(TabPvsa(1:n(k-1),5,k-1),TabPvsa(1:n(k-1),3,k-1),s);
                                hk(1)=interp1(TabPvsa(1:n(k-1),5,k-1),TabPvsa(1:n(k-1),4,k-1),s);
                                vk(1)=interp1(TabPvsa(1:n(k-1),5,k-1),TabPvsa(1:n(k-1),2,k-1),s);
                                Tk(2)=interp1(TabPvsa(1:n(k),5,k),TabPvsa(1:n(k),1,k),s);
                                uk(2)=interp1(TabPvsa(1:n(k),5,k),TabPvsa(1:n(k),3,k),s);
                                hk(2)=interp1(TabPvsa(1:n(k),5,k),TabPvsa(1:n(k),4,k),s);
                                vk(2)=interp1(TabPvsa(1:n(k),5,k),TabPvsa(1:n(k),2,k),s);
                                Pk=[Pvsa(k-1) Pvsa(k)];
                                T=interp1(Pk,Tk,P);
                                u=interp1(Pk,uk,P);
                                h=interp1(Pk,hk,P);
                                v=interp1(Pk,vk,P);
                            end
                        end
                    end
                elseif P < TabPlvs(1,1) | P > TabPlvs(end,1)
                    disp('Valor de pressão informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif (P~=0 & (x>=0 & x<=1)) & (T==0 & v==0 & u==0 & h==0 & s==0)
                i=find(TabPlvs(:,1)>=P,1);
                if i>0
                    Reg='MLV';
                    disp('Região: Mistura Líquido e Vapor Saturados')
                    T=interp1(TabPlvs(:,1),TabPlvs(:,2),P);
                    vl=interp1(TabPlvs(:,1),TabPlvs(:,3),P);
                    vv=interp1(TabPlvs(:,1),TabPlvs(:,4),P);
                    ul=interp1(TabPlvs(:,1),TabPlvs(:,5),P);
                    uv=interp1(TabPlvs(:,1),TabPlvs(:,7),P);
                    hl=interp1(TabPlvs(:,1),TabPlvs(:,8),P);
                    hv=interp1(TabPlvs(:,1),TabPlvs(:,10),P);
                    sl=interp1(TabPlvs(:,1),TabPlvs(:,11),P);
                    sv=interp1(TabPlvs(:,1),TabPlvs(:,13),P);
                    v=vl+x*(vv-vl);
                    u=ul+x*(uv-ul);
                    h=hl+x*(hv-hl);
                    s=sl+x*(sv-sl);
                elseif P < TabPlvs(1,1) | P > TabPlvs(end,1)
                    disp('Valor de pressão informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
            elseif ((T~=0 & v~=0) & (P==0 & u==0 & h==0 & s==0)) | ((T==0 & v~=0) & (P==0 & u==0 & h==0 & s==0))
                i=find(TabTlvs(:,1)>=T,1);
                if i>0
                    vlr=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                    vvr=interp1(TabTlvs(:,1),TabTlvs(:,4),T);
                    if v>=vlr & v<=vvr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        P=interp1(TabTlvs(:,1),TabTlvs(:,2),T);
                        vl=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                        vv=interp1(TabTlvs(:,1),TabTlvs(:,4),T);
                        ul=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                        uv=interp1(TabTlvs(:,1),TabTlvs(:,7),T);
                        hl=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                        hv=interp1(TabTlvs(:,1),TabTlvs(:,10),T);
                        sl=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                        sv=interp1(TabTlvs(:,1),TabTlvs(:,13),T);
                        x=(v-vl)/(vv-vl);
                        u=ul+x*(uv-ul);
                        h=hl+x*(hv-hl);
                        s=sl+x*(sv-sl);
                    elseif v<vlr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif v>vvr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        disp('Esta busca não está implementada!!!!!')
                    end
                elseif T < TabTlvs(1,1) | T > TabTlvs(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif ((T~=0 & u~=0) & (P==0 & v==0 & h==0 & s==0)) | ((T==0 & u~=0) & (P==0 & v==0 & h==0 & s==0))
                i=find(TabTlvs(:,1)>=T,1);
                if i>0
                    ulr=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                    uvr=interp1(TabTlvs(:,1),TabTlvs(:,7),T);
                    if u>=ulr & u<=uvr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        P=interp1(TabTlvs(:,1),TabTlvs(:,2),T);
                        vl=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                        vv=interp1(TabTlvs(:,1),TabTlvs(:,4),T);
                        ul=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                        uv=interp1(TabTlvs(:,1),TabTlvs(:,7),T);
                        hl=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                        hv=interp1(TabTlvs(:,1),TabTlvs(:,10),T);
                        sl=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                        sv=interp1(TabTlvs(:,1),TabTlvs(:,13),T);
                        x=(u-ul)/(uv-ul);
                        v=vl+x*(vv-vl);
                        h=hl+x*(hv-hl);
                        s=sl+x*(sv-sl);
                    elseif u<ulr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif u>uvr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        disp('Esta busca não está implementada!!!!!')
                    end
                elseif T < TabTlvs(1,1) | T > TabTlvs(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif ((T~=0 & h~=0) & (P==0 & u==0 & v==0 & s==0)) | ((T==0 & h~=0) & (P==0 & u==0 & v==0 & s==0))
                i=find(TabTlvs(:,1)>=T,1);
                if i>0
                    hlr=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                    hvr=interp1(TabTlvs(:,1),TabTlvs(:,10),T);
                    if h>=hlr & h<=hvr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        P=interp1(TabTlvs(:,1),TabTlvs(:,2),T);
                        vl=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                        vv=interp1(TabTlvs(:,1),TabTlvs(:,4),T);
                        ul=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                        uv=interp1(TabTlvs(:,1),TabTlvs(:,7),T);
                        hl=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                        hv=interp1(TabTlvs(:,1),TabTlvs(:,10),T);
                        sl=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                        sv=interp1(TabTlvs(:,1),TabTlvs(:,13),T);
                        x=(h-hl)/(hv-hl);
                        u=ul+x*(uv-ul);
                        v=vl+x*(vv-vl);
                        s=sl+x*(sv-sl);
                    elseif h<hlr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif h>hvr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        disp('Esta busca não está implementada!!!!!')
                    end
                elseif T < TabTlvs(1,1) | T > TabTlvs(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif ((T~=0 & s~=0) & (P==0 & u==0 & h==0 & v==0)) | ((T==0 & s~=0) & (P==0 & u==0 & h==0 & v==0))
                i=find(TabTlvs(:,1)>=T,1);
                if i>0
                    slr=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                    svr=interp1(TabTlvs(:,1),TabTlvs(:,13),T);
                    if s>=slr & s<=svr
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        P=interp1(TabTlvs(:,1),TabTlvs(:,2),T);
                        vl=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                        vv=interp1(TabTlvs(:,1),TabTlvs(:,4),T);
                        ul=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                        uv=interp1(TabTlvs(:,1),TabTlvs(:,7),T);
                        hl=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                        hv=interp1(TabTlvs(:,1),TabTlvs(:,10),T);
                        sl=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                        sv=interp1(TabTlvs(:,1),TabTlvs(:,13),T);
                        x=(s-sl)/(sv-sl);
                        u=ul+x*(uv-ul);
                        h=hl+x*(hv-hl);
                        v=vl+x*(vv-vl);
                    elseif s<slr
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        disp('Esta busca não está implementada!!!!!')
                    elseif s>svr
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        disp('Esta busca não está implementada!!!!!')
                    end
                elseif T < TabTlvs(1,1) | T > TabTlvs(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif ((T~=0 & (x>=0 & x<=1)) & (v==0 & u==0 & h==0 & s==0)) | ((T==0 & (x>=0 & x<=1)) & (v==0 & u==0 & h==0 & s==0))
                i=find(TabTlvs(:,1)>=T,1);
                if i>0
                    Reg='MLV';
                    disp('Região: Mistura Líquido e Vapor Saturados')
                    P=interp1(TabTlvs(:,1),TabTlvs(:,2),T);
                    vl=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                    vv=interp1(TabTlvs(:,1),TabTlvs(:,4),T);
                    ul=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                    uv=interp1(TabTlvs(:,1),TabTlvs(:,7),T);
                    hl=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                    hv=interp1(TabTlvs(:,1),TabTlvs(:,10),T);
                    sl=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                    sv=interp1(TabTlvs(:,1),TabTlvs(:,13),T);
                    v=vl+x*(vv-vl);
                    u=ul+x*(uv-ul);
                    h=hl+x*(hv-hl);
                    s=sl+x*(sv-sl);
                elseif T < TabTlvs(1,1) | T > TabTlvs(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
%--------------------------------------------------------------------------
            elseif ((v~=0 & (x==0 | x==1)) & (T==0 & u==0 & h==0 & s==0)) | ((T==0 & (x>=0 & x<=1)) & (v==0 & u==0 & h==0 & s==0))
                if x==0
                    i=find(TabTlvs(:,3)>=v,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,3),TabTlvs(:,1),v);
                        P=interp1(TabTlvs(:,3),TabTlvs(:,2),v);
                        vl=v;                        
                        vv=interp1(TabTlvs(:,3),TabTlvs(:,4),v);
                        ul=interp1(TabTlvs(:,3),TabTlvs(:,5),v);
                        uv=interp1(TabTlvs(:,3),TabTlvs(:,7),v);
                        hl=interp1(TabTlvs(:,3),TabTlvs(:,8),v);
                        hv=interp1(TabTlvs(:,3),TabTlvs(:,10),v);
                        sl=interp1(TabTlvs(:,3),TabTlvs(:,11),v);
                        sv=interp1(TabTlvs(:,3),TabTlvs(:,13),v);
                        u=ul;
                        h=hl;
                        s=sl;
                    elseif v < TabTlvs(1,3) | T > TabTlvs(end,3)
                        disp('Valor do volume específico informado está fora do intervalo de consulta!!!!!')                    
                    end
                elseif x==1
                    i=find(TabTlvs(:,4)>=v,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,4),TabTlvs(:,1),v);
                        P=interp1(TabTlvs(:,4),TabTlvs(:,2),v);
                        vl=interp1(TabTlvs(:,4),TabTlvs(:,3),v);                        
                        vv=v;
                        ul=interp1(TabTlvs(:,4),TabTlvs(:,5),v);
                        uv=interp1(TabTlvs(:,4),TabTlvs(:,7),v);
                        hl=interp1(TabTlvs(:,4),TabTlvs(:,8),v);
                        hv=interp1(TabTlvs(:,4),TabTlvs(:,10),v);
                        sl=interp1(TabTlvs(:,4),TabTlvs(:,11),v);
                        sv=interp1(TabTlvs(:,4),TabTlvs(:,13),v);
                        u=uv;
                        h=hv;
                        s=sv;
                    elseif v < TabTlvs(1,4) | T > TabTlvs(end,4)
                        disp('Valor do volume específico informado está fora do intervalo de consulta!!!!!')                    
                    end
                else
                    disp('O volume específico e o título diferente de 0 ou 1 não definem um estado.')
                end
%--------------------------------------------------------------------------
            elseif ((u~=0 & (x==0 | x==1)) & (T==0 & v==0 & h==0 & s==0)) | ((T==0 & (x>=0 & x<=1)) & (v==0 & u==0 & h==0 & s==0))
                if x==0
                    i=find(TabTlvs(:,5)>=u,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,5),TabTlvs(:,1),u);
                        P=interp1(TabTlvs(:,5),TabTlvs(:,2),u);
                        vl=interp1(TabTlvs(:,5),TabTlvs(:,3),u);                        
                        vv=interp1(TabTlvs(:,5),TabTlvs(:,4),u);
                        ul=u;
                        uv=interp1(TabTlvs(:,5),TabTlvs(:,7),u);
                        hl=interp1(TabTlvs(:,5),TabTlvs(:,8),u);
                        hv=interp1(TabTlvs(:,5),TabTlvs(:,10),u);
                        sl=interp1(TabTlvs(:,5),TabTlvs(:,11),u);
                        sv=interp1(TabTlvs(:,5),TabTlvs(:,13),u);
                        v=vl;
                        h=hl;
                        s=sl;
                    elseif u < TabTlvs(1,5) | u > TabTlvs(end,5)
                        disp('Valor da energia interna específica informado está fora do intervalo de consulta!!!!!')                    
                    end
                elseif x==1
                    i=find(TabTlvs(:,7)>=u,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,7),TabTlvs(:,1),u);
                        P=interp1(TabTlvs(:,7),TabTlvs(:,2),u);
                        vl=interp1(TabTlvs(:,7),TabTlvs(:,3),u);                        
                        vv=interp1(TabTlvs(:,7),TabTlvs(:,4),u);
                        ul=interp1(TabTlvs(:,7),TabTlvs(:,5),u);
                        uv=u;
                        hl=interp1(TabTlvs(:,7),TabTlvs(:,8),u);
                        hv=interp1(TabTlvs(:,7),TabTlvs(:,10),u);
                        sl=interp1(TabTlvs(:,7),TabTlvs(:,11),u);
                        sv=interp1(TabTlvs(:,7),TabTlvs(:,13),u);
                        v=vv;
                        h=hv;
                        s=sv;
                    elseif u < TabTlvs(1,7) | u > TabTlvs(end,7)
                        disp('Valor da energia interna específica informado está fora do intervalo de consulta!!!!!')                    
                    end
                else
                    disp('A energia interna específica e o título diferente de 0 ou 1 não definem um estado.')
                end
%--------------------------------------------------------------------------
            elseif ((h~=0 & (x==0 | x==1)) & (T==0 & v==0 & u==0 & s==0)) | ((T==0 & (x>=0 & x<=1)) & (v==0 & u==0 & h==0 & s==0))
                if x==0
                    i=find(TabTlvs(:,8)>=h,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,8),TabTlvs(:,1),h);
                        P=interp1(TabTlvs(:,8),TabTlvs(:,2),h);
                        vl=interp1(TabTlvs(:,8),TabTlvs(:,3),h);                        
                        vv=interp1(TabTlvs(:,8),TabTlvs(:,4),h);
                        ul=interp1(TabTlvs(:,8),TabTlvs(:,5),h);
                        uv=interp1(TabTlvs(:,8),TabTlvs(:,7),h);
                        hl=h;
                        hv=interp1(TabTlvs(:,8),TabTlvs(:,10),h);
                        sl=interp1(TabTlvs(:,8),TabTlvs(:,11),h);
                        sv=interp1(TabTlvs(:,8),TabTlvs(:,13),h);
                        v=vl;
                        u=ul;
                        s=sl;
                    elseif h < TabTlvs(1,8) | h > TabTlvs(end,8)
                        disp('Valor da entalpia específica informado está fora do intervalo de consulta!!!!!')                    
                    end
                elseif x==1
                    i=find(TabTlvs(:,10)>=h,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,10),TabTlvs(:,1),h);
                        P=interp1(TabTlvs(:,10),TabTlvs(:,2),h);
                        vl=interp1(TabTlvs(:,10),TabTlvs(:,3),h);                        
                        vv=interp1(TabTlvs(:,10),TabTlvs(:,4),h);
                        ul=interp1(TabTlvs(:,10),TabTlvs(:,5),h);
                        uv=interp1(TabTlvs(:,10),TabTlvs(:,7),h);
                        hl=interp1(TabTlvs(:,10),TabTlvs(:,8),h);
                        hv=h;
                        sl=interp1(TabTlvs(:,10),TabTlvs(:,11),h);
                        sv=interp1(TabTlvs(:,10),TabTlvs(:,13),h);
                        v=vv;
                        u=uv;
                        s=sv;
                    elseif h < TabTlvs(1,10) | h > TabTlvs(end,10)
                        disp('Valor da entalpia específica informado está fora do intervalo de consulta!!!!!')                    
                    end
                else
                    disp('A entalpia específica e o título diferente de 0 ou 1 não definem um estado.')
                end
%--------------------------------------------------------------------------
            elseif ((s~=0 & (x==0 | x==1)) & (T==0 & v==0 & u==0 & h==0)) | ((T==0 & (x>=0 & x<=1)) & (v==0 & u==0 & h==0 & s==0))
                if x==0
                    i=find(TabTlvs(:,11)>=s,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,11),TabTlvs(:,1),s);
                        P=interp1(TabTlvs(:,11),TabTlvs(:,2),s);
                        vl=interp1(TabTlvs(:,11),TabTlvs(:,3),s);                        
                        vv=interp1(TabTlvs(:,11),TabTlvs(:,4),s);
                        ul=interp1(TabTlvs(:,11),TabTlvs(:,5),s);
                        uv=interp1(TabTlvs(:,11),TabTlvs(:,7),s);
                        hl=interp1(TabTlvs(:,11),TabTlvs(:,8),s);
                        hv=interp1(TabTlvs(:,11),TabTlvs(:,10),s);
                        sl=s;
                        sv=interp1(TabTlvs(:,11),TabTlvs(:,13),s);
                        v=vl;
                        u=ul;
                        h=hl;
                    elseif s < TabTlvs(1,11) | s > TabTlvs(end,11)
                        disp('Valor da entropia específica informado está fora do intervalo de consulta!!!!!')                    
                    end
                elseif x==1
                    i=find(TabTlvs(:,13)>=s,1);
                    if i>0
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        T=interp1(TabTlvs(:,13),TabTlvs(:,1),s);
                        P=interp1(TabTlvs(:,13),TabTlvs(:,2),s);
                        vl=interp1(TabTlvs(:,13),TabTlvs(:,3),s);                        
                        vv=interp1(TabTlvs(:,13),TabTlvs(:,4),s);
                        ul=interp1(TabTlvs(:,13),TabTlvs(:,5),s);
                        uv=interp1(TabTlvs(:,13),TabTlvs(:,7),s);
                        hl=interp1(TabTlvs(:,13),TabTlvs(:,8),s);
                        hv=interp1(TabTlvs(:,13),TabTlvs(:,10),s);
                        sl=interp1(TabTlvs(:,13),TabTlvs(:,11),s);
                        sv=s;
                        v=vv;
                        u=uv;
                        h=hv;
                    elseif s < TabTlvs(1,13) | s > TabTlvs(end,13)
                        disp('Valor da entropia específica informado está fora do intervalo de consulta!!!!!')                    
                    end
                else
                    disp('A entropia específica e o título diferente de 0 ou 1 não definem um estado.')
                end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
            elseif ((T~=0 & P~=0) & (v==0 & u==0 & h==0 & s==0)) | ((T==0 & P~=0) & (v==0 & u==0 & h==0 & s==0))
                i=find(TabTlvs(:,1)>=T,1);
                if i>0
                    Psat=interp1(TabTlvs(:,1),TabTlvs(:,2),T);
                    if P==Psat
                        Reg='MLV';
                        disp('Região: Mistura Líquido e Vapor Saturados')
                        disp('O par temperatura e pressão são os de saturação!!!!!')
                        disp('Para definir o estado é necessário uma terceira propriedade intensiva ou o título.')
                    elseif P>Psat
                        Reg='ALC';
                        disp('Região: Líquido Comprimido')
                        v=interp1(TabTlvs(:,1),TabTlvs(:,3),T);
                        u=interp1(TabTlvs(:,1),TabTlvs(:,5),T);
                        h=interp1(TabTlvs(:,1),TabTlvs(:,8),T);
                        %h=h+v*(P-Psat);
                        s=interp1(TabTlvs(:,1),TabTlvs(:,11),T);
                    else
                        Reg='VSA';
                        disp('Região: Vapor Superaquecido')
                        j=find(Pvsa(:)==P,1);
                        if j>0
                            v=interp1(TabPvsa(1:n(j),1,j),TabPvsa(1:n(j),2,j),T);
                            u=interp1(TabPvsa(1:n(j),1,j),TabPvsa(1:n(j),3,j),T);
                            h=interp1(TabPvsa(1:n(j),1,j),TabPvsa(1:n(j),4,j),T);
                            s=interp1(TabPvsa(1:n(j),1,j),TabPvsa(1:n(j),5,j),T);
                        else
                            k=find(Pvsa(:)>P,1);
                            if k>0
                                vk(1)=interp1(TabPvsa(1:n(k-1),1,k-1),TabPvsa(1:n(k-1),2,k-1),T);
                                uk(1)=interp1(TabPvsa(1:n(k-1),1,k-1),TabPvsa(1:n(k-1),3,k-1),T);
                                hk(1)=interp1(TabPvsa(1:n(k-1),1,k-1),TabPvsa(1:n(k-1),4,k-1),T);
                                sk(1)=interp1(TabPvsa(1:n(k-1),1,k-1),TabPvsa(1:n(k-1),5,k-1),T);
                                vk(2)=interp1(TabPvsa(1:n(k),1,k),TabPvsa(1:n(k),2,k),T);
                                uk(2)=interp1(TabPvsa(1:n(k),1,k),TabPvsa(1:n(k),3,k),T);
                                hk(2)=interp1(TabPvsa(1:n(k),1,k),TabPvsa(1:n(k),4,k),T);
                                sk(2)=interp1(TabPvsa(1:n(k),1,k),TabPvsa(1:n(k),5,k),T);
                                Pk=[Pvsa(k-1) Pvsa(k)];
                                v=interp1(Pk,vk,P);
                                u=interp1(Pk,uk,P);
                                h=interp1(Pk,hk,P);
                                s=interp1(Pk,sk,P);
                            end
                        end
                    end
                elseif T < TabTlvs(1,1) | T > TabTlvs(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
            end
            
            VetPropSubPurSai=[T P v u h s x vl vv ul uv hl hv sl sv];
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
        elseif (TipTab==' AR  ') & (contPropGI==1)
            T=VetPropGasIdEnt(1); u=VetPropGasIdEnt(2); h=VetPropGasIdEnt(3); 
            s0=VetPropGasIdEnt(4); vr=VetPropGasIdEnt(5); Pr=VetPropGasIdEnt(6);
%--------------------------------------------------------------------------
            if T~=0 & (h==0 & u==0 & s0==0 & vr==0 & Pr==0)
                i=find(TabArGI(:,1)>=T,1);
                if i>0
                    h=interp1(TabArGI(:,1),TabArGI(:,2),T);
                    Pr=interp1(TabArGI(:,1),TabArGI(:,3),T);
                    u=interp1(TabArGI(:,1),TabArGI(:,4),T);
                    vr=interp1(TabArGI(:,1),TabArGI(:,5),T);
                    s0=interp1(TabArGI(:,1),TabArGI(:,6),T);
                elseif T < TabArGI(1,1) | T > TabArGI(end,1)
                    disp('Valor de temperatura informado está fora do intervalo de consulta!!!!!')                    
                end
            end
%--------------------------------------------------------------------------
            if h~=0 & (T==0 & u==0 & s0==0 & vr==0 & Pr==0)
                i=find(TabArGI(:,2)>=h,1);
                if i>0
                    T=interp1(TabArGI(:,2),TabArGI(:,1),h);
                    Pr=interp1(TabArGI(:,2),TabArGI(:,3),h);
                    u=interp1(TabArGI(:,2),TabArGI(:,4),h);
                    vr=interp1(TabArGI(:,2),TabArGI(:,5),h);
                    s0=interp1(TabArGI(:,2),TabArGI(:,6),h);
                elseif h < TabArGI(1,2) | h > TabArGI(end,2)
                    disp('Valor de entalpia informado está fora do intervalo de consulta!!!!!')                    
                end
            end
%--------------------------------------------------------------------------
            if u~=0 & (T==0 & h==0 & s0==0 & vr==0 & Pr==0)
                i=find(TabArGI(:,4)>=u,1);
                if i>0
                    T=interp1(TabArGI(:,4),TabArGI(:,1),u);
                    Pr=interp1(TabArGI(:,4),TabArGI(:,3),u);
                    h=interp1(TabArGI(:,4),TabArGI(:,2),u);
                    vr=interp1(TabArGI(:,4),TabArGI(:,5),u);
                    s0=interp1(TabArGI(:,4),TabArGI(:,6),u);
                elseif u < TabArGI(1,4) | u > TabArGI(end,4)
                    disp('Valor de energia interna específica informado está fora do intervalo de consulta!!!!!')                    
                end
            end
%--------------------------------------------------------------------------
            if s0~=0 & (T==0 & h==0 & u==0 & vr==0 & Pr==0)
                i=find(TabArGI(:,6)>=s0,1);
                if i>0
                    T=interp1(TabArGI(:,6),TabArGI(:,1),s0);
                    Pr=interp1(TabArGI(:,6),TabArGI(:,3),s0);
                    h=interp1(TabArGI(:,6),TabArGI(:,2),s0);
                    vr=interp1(TabArGI(:,6),TabArGI(:,5),s0);
                    u=interp1(TabArGI(:,6),TabArGI(:,4),s0);
                elseif s0 < TabArGI(1,6) | s0 > TabArGI(end,6)
                    disp('Valor da Integral de "cp(T)/T" de T0 a T informado está fora do intervalo de consulta!!!!!')                    
                end
            end
%--------------------------------------------------------------------------
            if vr~=0 & (T==0 & h==0 & u==0 & s0==0 & Pr==0)
                i=find(TabArGI(:,5)>=vr,1);
                if i>0
                    T=interp1(TabArGI(:,5),TabArGI(:,1),vr);
                    Pr=interp1(TabArGI(:,5),TabArGI(:,3),vr);
                    h=interp1(TabArGI(:,5),TabArGI(:,2),vr);
                    s0=interp1(TabArGI(:,5),TabArGI(:,6),vr);
                    u=interp1(TabArGI(:,5),TabArGI(:,4),vr);
                elseif vr < TabArGI(1,5) | vr > TabArGI(end,5)
                    disp('Valor do volume específico relativo informado está fora do intervalo de consulta!!!!!')                    
                end
            end
%--------------------------------------------------------------------------
            if Pr~=0 & (T==0 & h==0 & u==0 & s0==0 & vr==0)
                i=find(TabArGI(:,3)>=Pr,1);
                if i>0
                    T=interp1(TabArGI(:,3),TabArGI(:,1),Pr);
                    vr=interp1(TabArGI(:,3),TabArGI(:,5),Pr);
                    h=interp1(TabArGI(:,3),TabArGI(:,2),Pr);
                    s0=interp1(TabArGI(:,3),TabArGI(:,6),Pr);
                    u=interp1(TabArGI(:,3),TabArGI(:,4),Pr);
                elseif Pr < TabArGI(1,3) | Pr > TabArGI(end,3)
                    disp('Valor da pressão relativa informado está fora do intervalo de consulta!!!!!')                    
                end
            end
%--------------------------------------------------------------------------
            VetPropGasIdSai=[T u h s0 vr Pr];
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
        else
            disp('Não foi feita a opção correta do fluido de trabalho!!!!!')
            disp('Ou não foi escolhida a quantidade correta de propriedades para caracterizar o estado!!!!!')
        end
        
    end

    
end