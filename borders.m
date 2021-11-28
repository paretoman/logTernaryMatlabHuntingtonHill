%%
% show borders between regions
% This is for allocating seats using the Huntington-Hill method.
% There are three parties, x,y,z.
% We want to show the space of all possible proportions of populations of
% these parties and the seat allocation that would best match these
% proportions according to Huntington-Hill.

clf
m = 9; % number of seats
s = 1/m;
axis equal
hold on
for z=s:s:(1-s)
    for x = s:s:(1-z-s)
        y = 1 - x - z;
        % plot( 1/2 * ( -x + y ) , 1/(2*sqrt(3)) * ( -x - y + 2*z ) ,'o')
        
        % Draw dots for each possible combination of seats for the three
        % parties.
        plot( 1/2 * ( -log(x) + log(y) ) , 1/(2*sqrt(3)) * ( -log(x) - log(y) + 2 * log(z) ), '.','MarkerSize',30, 'MarkerEdgeColor',([x y z]/(x+y+z)).^.5)
        
        % find neighbors of the dots so we can find their borders
        right_x = x;
        right_y = y + s;
        right_z = z - s;
        left_x = x + s;
        left_y = y;
        left_z = z - s;
        down_x = x + s;
        down_y = y + s;
        down_z = z - 2*s;
        
        % find top and bottom of line. Only the ratios matter, so assume
        % the z coordinate is 1. Then use the raios to find the other
        % coordinates.
        top_xy = sqrt( (right_x / right_y) * (left_x / left_y) );
        top_yz = sqrt( (right_y / right_z) * (y / z) );
        top_z = 1;
        top_y = top_yz;
        top_x = top_xy * top_yz;
        bottom_xy = top_xy;
        if down_z == 0
            down_z = s*.5;
        end
        bottom_yz = sqrt( (left_y / left_z) * (down_y / down_z) );
        bottom_z = 1;
        bottom_y = bottom_yz;
        bottom_x = bottom_xy * bottom_yz;
        t = 0:1:1;
        xt = top_x .* (1-t) + bottom_x .* t;
        yt = top_y .* (1-t) + bottom_y .* t;
        zt = top_z .* (1-t) + bottom_z .* t;
        
        % draw borders in all three directions.
        plot( 1/2 * ( log(yt./xt) ) , 1/(2*sqrt(3)) * ( log(zt.^2./(xt.*yt)) ) ,'k')
        plot( 1/2 * ( log(zt./yt) ) , 1/(2*sqrt(3)) * ( log(xt.^2./(yt.*zt)) ) ,'k')
        plot( 1/2 * ( log(xt./zt) ) , 1/(2*sqrt(3)) * ( log(yt.^2./(zt.*xt)) ) ,'k')
    end
end

% make tick marks at whole number fractions
xt = [];
xtl = {};
for n = 1:1:(m-1)
    d = m - n - 1;
    xt(n) = 1/2 * log(n/d);
    xtl{n} = strjoin([ num2str(n) ":" num2str(d) ]);
end
xticks(xt);
xticklabels(xtl);
yticks([]);
xlabel('Party A to B Ratio, Log Scale');
title({'Huntington-Hill Allocations for Three Parties,','For All Proportions of A:B:C Party Population,',' in Log Ternary Space',['For ' num2str(m) ' seats']});
hold off
