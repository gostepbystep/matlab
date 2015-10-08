function [f, g] = stpMinDecisionFunc(x)
    f = stpMinFunc(x);
    %g = mb_numDiff(@stpMinFunc,x);
    g = [];
end

function [f] = stpMinFunc(x3)
    global global_x global_mean global_invCov globa_c;

    global_x(3, 1) = x3;
    g1 = stpGFunc(global_x, global_mean(:, 1), global_invCov{1}, globa_c(1) );
    g2 = stpGFunc(global_x, global_mean(:, 2), global_invCov{2}, globa_c(2) );
    
    f = norm(g1-g2, 2);

end

