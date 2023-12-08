function M = modelo(x)
    disp('entrei modelo')

    M = x(1)^2 + x(2)^2 +25*((sin(x(1)))^2+(sin(x(2)))^2);
//    x^{2}+y^{2}+25(\sin ^{2}x+\sin ^{2}y)       
endfunction
