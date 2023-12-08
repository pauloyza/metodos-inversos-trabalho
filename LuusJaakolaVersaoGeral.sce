// *******************************************************************
// Luus-Jaakola - Adaptado do código em C de Wagner R. Telles para 
// obter os parâmetros da curva de retenção de Van Genuchten 
// usando código para resolver a equação de Richards.
// Desenvolvido por Fábio Freitas Ferreira
// 28/10/2019
// *******************************************************************
clear
clc
// No caso de métodos estocásticos, é bom dar várias rodadas para verificar
// a confiabilidade do método. Aqui está programado para 1 rodada apenas.
rodada=1; 

// Este comando permite identificar a pasta de trabalho automaticamente.
ENDERECO       = get_absolute_file_path('LuusJaakolaVersaoGeral.sce');

// Após criar uma pasta de trabalho, que será capturada pelo comando
// get_absolute_file_path, o usuário deverá criar duas pastas de 
// trabalho, INPUT_ADDRESS e OUTPUT_ADDRESS, onde serão lidos dados 
// do problema e salva a solução.

//Parâmetros do Método Luss-Jaakola
QTDVAR    = 2;   // Número de Variáveis do problema
NOUT      = 35;   // Número de iteracoes externas
NINT      = 25;   // Número de iteracoes internas
EPS       = 0.20;// Fator de redução do intervalo de busca
r         = zeros(QTDVAR,1); // Amplitude do intervalo de busca
mini      = zeros(QTDVAR,1); // Restrição do problema.
maxi      = zeros(QTDVAR,1); // Restrição do problema.
x_inicial = zeros(QTDVAR,1); // solução inicial.
x_otimo   = zeros(QTDVAR,1); // solucao ótima.

//Inicialização do intervalo de busca
mini(1) = -2*%pi;   //Valor minimo do intervalo de busca de x_otimo(1)
maxi(1) = 2*%pi;   //Valor maximo do intervalo de busca de x_otimo(1)
mini(2) = -2*%pi; //Valor minimo do intervalo de busca de x_otimo(2)
maxi(2) = 2*%pi;   //Valor maximo do intervalo de busca de x_otimo(2)


exec(ENDERECO+'funcao.sci');

// Geração do intervalo de busca e da estimativa inicial
cont = 0;
for (i = 1:QTDVAR)
    r(i)         = maxi(i) - mini(i);          // Intervalo de busca da solucao
    x_inicial(i) = mini(i) + (r(i) * rand(0)); // Estimativa Inicial
end
x_otimo      = x_inicial;

// Cálculo da FUNCAO
disp(x_otimo)
fx_otimo = funcao(x_otimo);

printf("Estimativa inicial:\n");
printf(" %d\t %.4f\t\t %.4f\t\t", cont, x_otimo(1), x_otimo(2));

//Método de Luus-Jaakola
for (i = 1:NOUT) //Numero de iteracoes externas do programa
    for (j = 1:NINT) //Numero de iteracoes internas
        for (k = 1:QTDVAR) //Definindo o novo vetor solucao
            // Candidato a solução gerado aleatoriamente
            x_inicial(k) = x_otimo(k) + (r(k) * (-0.5 + rand(0))); 
            // Imposição das restrições
            if (x_inicial(k) < mini(k))
                x_inicial(k) = mini(k);
            end
            if (x_inicial(k) > maxi(k)) 
                x_inicial(k) = maxi(k);
            end
        end

        fx = funcao(x_inicial);

        // Se a nova estimativa for melhor que a anterior
        // haverá uma atualização do x_ótimo
        // > POnto maximo / < ponto minimo COMENTARIO DO PAULO
        if (fx > fx_otimo) 
            for (k = 1:QTDVAR)
                x_otimo(k) = x_inicial(k);
            end
            fx_otimo = fx;
        end
        cont = cont+1;
        printf(" %d\t %.4f\t\t %.4f\t\t", cont, x_otimo(1), x_otimo(2));
    end

    // Redução do intervalo de busca.
    for (k = 1:QTDVAR)
        r(k) = r(k) * (1 - EPS); //Novo intervalo de busca.
    end
end

