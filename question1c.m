% initialize x and y
a = -1;
b = 1;
xy = (b-a).*rand(2,1) + a;
x = xy(1);
y = xy(2);

%initialize parameters
thre = 1e-8;%control when to stop
delt = [10000;10000];
iter = 0;
ITER = [];
X = [];
Y = [];
FXY = [];

while delt(1)>thre || delt(2)>thre
    %record trajectory
    iter = iter+1;
    ITER(iter) = iter;
    X(iter) = x;
    Y(iter) = y;
    FXY(iter) = f(x,y);
    
    pre_x = x;
    pre_y = y;
    he = inv(h(x,y));
    gra1 = g1(x,y);
    gra2 = g2(x,y);
    hg = he*[gra1;gra2];
    x = pre_x - hg(1);
    y = pre_y - hg(2);
    delt = [abs(x - pre_x);abs(y - pre_y)];
    
    
end


%plot 
figure;
plot(X,Y);
figure;
plot(ITER,FXY);
figure;
plot(ITER,X);
figure;
plot(ITER,Y);

function F = f(x,y)
F = (1-x)^2 + 100*(y-x^2)^2;
end
%initialize g(k)
function G1 = g1(x,y)
G1 = 400*x^3 - 400*y*x + 2*x - 2;
end
function G2 = g2(x,y)
G2 = 200 * (y-x^2);
end
%initialize H(n)
function H = h(x,y)
H = [1200*x^2-400*y+2,-400*x;-400*x,200];
end