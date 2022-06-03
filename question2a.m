%generate train and test dataset and outlier data
train_x = [-1.6:0.05:1.6];
train_y = of(train_x);
test_x = [-1.6:0.01:1.6];
test_y = of(test_x);
train_x = num2cell(train_x,1);
test_x = num2cell(test_x,1);
train_y = num2cell(train_y,1);
test_y = num2cell(test_y,1);
out_x1 = 3;
out_x2 = -3;
out_y1 = of(out_x1);
out_y2 = of(out_x2);

%initial parameters
epochs = 1000;
n = [1,2,3,4,5,6,7,8,9,10,20,50,100];
result_out_x1 =[];
result_out_x2 =[];


for i =1:length(n)
    net = train_seq(n(i),train_x,train_y,epochs);
    result_testx = net(test_x);
    result_out_x1 = [result_out_x1, net(out_x1)];
    result_out_x2 = [result_out_x2, net(out_x2)];
    figure;
    plot(cell2mat(test_x), cell2mat(result_testx), cell2mat(test_x), cell2mat(test_y));
    
end

% Objective function
function OF = of(x)
OF = 1.2*sin(pi*x)-cos(2.4*pi*x);
end

function net= train_seq(n,x,y,epochs )
 net = fitnet(n,'traingd');% Gradient descent backpropagation
 net.layers{1}.transferFcn = 'tansig'; %based on lecture 4
 net.layers{2}.transferFcn = 'purelin'; %based on lecture 4
 %  Train the network in sequential mode
for i = 1 : epochs
    idx = randperm(length(x)); % shuffle the input
    net = adapt(net, x(:,idx), y(:,idx));
end
end