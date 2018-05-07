function [local,contrast] = edge_width(ori_img)
% Syntax:[local,contrast] = edge_width(ori_img)
% use edge model to compute the width of each edge pixel.
%
% ori_image is the image to be processed.
% local is a matrix of the same size of the ori_img. Value of each point
% represents the computed edge width of each detected edge point(A point
% belongs to an edge).
% contrast is a matrix of the same size of the ori_img. Value of each point
% represents the computed contrast of each detected edge point(A point
% belongs to an edge).
% 
% Reference:
% Guan J, Zhang W, Gu J, et al. No-reference Blur Assessment Based on Edge
% Modeling[J]. Journal of Visual Communication and Image Representation,
% 2015. 

ori_img = double(ori_img);

[m,n] = size(ori_img);
sigma=0.72;                

ssq = sigma^2;
width = 7;              

t = (-width:width);
%gau = exp(-(t..*t)/(2*ssq))/(2*pi*ssq);     % the gaussian 1D filter

[x,y]=meshgrid(-width:width,-width:width);

dgau2D=-y.*exp(-(x.*x+y.*y)/(2*ssq))/(2*pi*ssq.*ssq); 
dgau2D=dgau2D';                     

[Tmp_x,Tmp_y,Sum_x,Sum_y,X_detect,Y_detect,XXX] = mag2(ori_img,dgau2D);	

X_detect=X_detect';
Y_detect=Y_detect';
mag = sqrt((X_detect.*X_detect) + (Y_detect.*Y_detect));

PI = 3.1415929;
PI2 = 1.5707965;
EDGE = 255;               
SHADE = 0;               
MID = 100;              
m_min_gradient = 13.6 ;                     
width_points = zeros(m, n);
edge_q = zeros(m, n);
edge_c = zeros(m, n);

for i = 2: m-1      
    for j = 2: n-1
        detect(i,j)=0;
        if abs(mag(i,j)) > m_min_gradient.*0.5
            u=X_detect(i,j);
            v=Y_detect(i,j);
            if v == 0.0
                if u > 0.0
                    edge_q(i,j)=0.0;
                    o=mag(i-1,j);
                    p=mag(i+1,j);
                else
                    edge_q(i,j)=PI;
                    o=mag(i+1,j);
                    p=mag(i-1,j);
                end
            else if u == 0
                    if v > 0.0
                        edge_q(i,j) = 0.5.*PI;
                        o=mag(i,j-1);
                        p=mag(i,j+1);
                    else
                        edge_q(i,j) = -0.5.*PI;
                        o=mag(i,j+1);
                        p=mag(i,j-1);
                    end
                else if (u.*v) > 0.0
                        q=v/u;
                        if u > 0.0
                            edge_q(i,j) = atan(q);
                            % if 1<i<m
                            if q <= 1.0
                                o=q.*mag(i-1,j-1)+(1.0-q).*mag(i-1,j);
                                p=q.*mag(i+1,j+1)+(1.0-q).*mag(i+1,j);
                            else
                                q=1.0/q;
                                o=q.*mag(i-1,j-1)+(1.0-q).*mag(i,j-1);
                                p=q.*mag(i+1,j+1)+(1.0-q).*mag(i,j+1);
                            end  
                        else
                            edge_q(i,j)=atan(q)-PI;
                            if  q<=1.0
                                o=q.*mag(i+1,j+1)+(1.0-q).*mag(i+1,j);
                                p=q.*mag(i-1,j-1)+(1.0-q).*mag(i-1,j);
                            else
                                q=1.0/q;
                                o=q.*mag(i+1,j+1)+(1.0-q).*mag(i,j+1);
                                p=q.*mag(i-1,j-1)+(1.0-q).*mag(i,j-1);
                            end
                        end
                    else
                        q=abs(v/u);
                        if u > 0
                            edge_q(i,j)=-1.0.*atan(q);
                            if q <= 1.0
                                o=q.*mag(i-1,j+1)+(1.0-q).*mag(i-1,j);   
                                p=q.*mag(i+1,j-1)+(1.0-q).*mag(i+1,j);
                            else
                                q=1.0/q;
                                o=q.*mag(i-1,j+1)+(1.0-q).*mag(i,j+1);   
                                p=q.*mag(i+1,j-1)+(1.0-q).*mag(i,j-1);
                            end
                        else 
                            edge_q(i,j)=PI-atan(q);  
                            if q <= 1.0          
                                o=q.*mag(i+1,j-1)+(1.0-q).*mag(i+1,j);
                                p=q.*mag(i-1,j+1)+(1.0-q).*mag(i-1,j);
                            else
                                q=1.0/q;
                                o=q.*mag(i+1,j-1)+(1.0-q).*mag(i,j-1);   
                                p=q.*mag(i-1,j+1)+(1.0-q).*mag(i,j+1);
                            end
                        end
                    end
                end        
            end
            if mag(i,j) >= o && mag(i,j) >= p
                if  abs(mag(i,j))>m_min_gradient
                    detect(i,j)=EDGE;
                else
                    detect(i,j)=MID;
                end

                d1=mag(i,j);
                d2=o;
                d3=p;
                if d3<1e-10
                    d3=1e-10;
                end
                if d2<1e-10
                    d2=1e-10;
                end
                if abs( edge_q(i,j)) == PI2    
                    q=0.0;
                else if  edge_q(i,j)==0.0|| edge_q(i,j)==PI
                        q=0.0;
                    else
                        q=abs(tan( edge_q(i,j)));
                        if q > 1.0
                            q=1.0/q;
                        end
                    end
                end
                p=log(d1.*d1/d2/d3);   
                u=sqrt(1.0+q.*q);                  
                %                    a = 1;                              
                m_sigmad=sigma;           
                v=(u.*u/p-m_sigmad.*m_sigmad);
                if v<0.0
                    v=0.01;                      
                end
                width_points(i,j)=sqrt(v);
                w=power((d2/d3),(0.25/u));                  
                t=sqrt(2.0*PI*u*u/p);
                edge_c(i,j)=d1*t*w;
            end 
        end
    end
end
 
 
for i=1:m                               
    for j=1:n
        if width_points(i,j)>= 14;
            width_points(i,j) = 0;
            edge_c(i,j) = 0;
        end
    end
end

for i=1:m
    for j=1:n
        if edge_c(i,j)>=255
            width_points(i,j) = 0;
            edge_c(i,j) = 0;
        end
    end
end
for i=1:m
     for j=1:n
        if width_points(i,j)<= 0.2;
          width_points(i,j) = 0;
          edge_c(i,j) = 0;
        end
    end
end

for i=1:m
    for j=1:n
        if edge_c(i,j)<=8
            width_points(i,j) = 0;
            edge_c(i,j) = 0;
        end
    end
end  
local = width_points;
contrast = edge_c;