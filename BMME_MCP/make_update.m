function[U, V] = make_update(grad_U,grad_V,grad_h_U,grad_h_V,c_1,c_2,L,w_U,w_V,fun_num)
    
    tpk = grad_U/L - grad_h_U;
    tqk = grad_V/L - grad_h_V;
    
    if(fun_num==1)
        pk =  max(0,abs(tpk) - lam/L).*sign(-tpk);
        qk =  max(0,abs(tqk) - lam/L).*sign(-tqk);
    end
    
    if(fun_num == 0)
        pk = wthresh(-tpk,'h',lam/L);
        qk = wthresh(-tqk,'h',lam/L);
        
    end
    
    if(fun_num==5)
        
        pk = -tpk(:);
        [~,ind] = sort(pk,'ascend');
        pk(ind(1:(end-lam))) = 0;
        pk = reshape(pk,size(tpk,1),size(tpk,2));
        
        qk = -tqk(:);
        [~,ind] = sort(qk,'ascend');
        qk(ind(1:(end-lam))) = 0;
        qk = reshape(qk,size(tqk,1),size(tqk,2));

        
    end
    
    
    if(fun_num==2)
        tpk = tpk(:);
        tqk = tqk(:);
        
        pk = proximalRegC(-tpk, length(tpk), lam/L, ga,1);
        
        qk = proximalRegC(-tqk, length(tqk), lam/L, ga,1);
        
        pk = reshape(pk,size(grad_U,1),size(grad_U,2));
        qk = reshape(qk,size(grad_V,1),size(grad_V,2));
        
    end
    
    if(fun_num==3)
        tpk = tpk(:);
        tqk = tqk(:);
        
        pk = proximalRegC(-tpk, length(tpk), lam/L, ga,2);
        
        qk = proximalRegC(-tqk, length(tqk), lam/L, ga,2);
        
        pk = reshape(pk,size(grad_U,1),size(grad_U,2));
        qk = reshape(qk,size(grad_V,1),size(grad_V,2));
        
    end
    
    if(fun_num==4)
%         size(tpk)
%         size(w_U)
        pk =  max(0,abs(tpk) - w_U/L).*sign(-tpk);
        qk =  max(0,abs(tqk) - w_V/L).*sign(-tqk);
    end
    
    if(fun_num==6)
        pk =  max(0,-tpk - lam*ga/L);
        qk =  max(0,-tqk - lam*ga/L);
    end
    
    % solve cubic equation:
    coeff = [c_1*(norm(pk,'fro')^2 + norm(qk,'fro')^2), 0, c_2, -1];
    temp = roots(coeff);
%     fprintf('root %.2d \n', temp);
    if(length(temp)==3)
       r = temp(3); 
    else
        r = temp;
    end
    
    U = r*pk;
    V = r*qk;

end