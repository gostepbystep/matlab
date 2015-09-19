%% stpMinBFGS

%         m=0;    
%         lamda = 1;        % ???? rho^0
% 
%         old = fk; 
%         delta = sigma * gk' * dk;
%         while(m < 20)
%             [new, ~] = fun(x0 + lamda*dk);  
% 
%             if(new <= delta*lamda + old)       
%                 break;         
%             end         
% 
%             m = m + 1;     
%             lamda = lamda * rho;
%         end 
% 
%         old = abs(v * gk' * dk);
%         m = 0;
%         while(m < 20)
%             [~, gnew] = fun(x0 + lamda*dk);
%             
%             new = abs( gnew' * dk);
% 
%             if(new <= old)       
%                 break;         
%             end         
% 
%             m = m + 1;     
%             lamda = lamda * rho;
%         end 

%%