// Disciplina: Problemas Inversos em Engenharia e Computação RCN00058
// Universidade Federal Fluminense - Departamento de Ciências da Natureza
// Prof. Dr. Fábio Freitas Ferreira
// Autor: Fábio Freitas Ferreira
// --------------------------
// Limpeza de memória
clear
clc

// ---------------------------
// Captura do endereço em que o arquivo coef_sensi.sce está salvo.
address  = get_absolute_file_path('coef_sensi.sce');
exec(address+'\modelo.sci');

// Criação do vetor que armazenará o coeficiente de sensibilidade.
X1 = zeros(200,1)
X2 = zeros(200,1)

// Coeficiente de sensibilidade da entrada 1
// Este trecho deverá ser copiado para cada entrada analisada.
for i=1:201
    x_aux = -2*%pi+(2*(i/100)-0.02)*%pi
    x      =[x_aux,%pi]
    xdelta =[x_aux + 0.1*abs(x_aux),%pi]
    X1(i)  = (modelo(xdelta) - modelo(x))/(0.1*(x_aux))
end

// Construção do gráfico.
dominio = [-100:1:100]
plot(dominio,X1,'k-o')
hl.font_size = 5.5
xlabel 'Domínio'  fontsize 5
ylabel 'Coeficiente de Sensibilidade' fontsize 5
hl=legend(['$X_1$'],opt=1);
hl.font_size = 5.5
