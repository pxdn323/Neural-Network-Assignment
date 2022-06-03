%read in images as train and test
file_manmade = './group_1/automobile/';%0
file_animal = './group_1/dog/';%1
train_manmade = [];
train_animal = [];
test_manmade = [];
test_animal = [];
epochs = 200;
n = [10,20,30,40,50,100,150,200];

for i = 0:449
    name_manmade = [file_manmade,num2str(i,'%03d'),'.jpg'];
    name_animal = [file_animal,num2str(i,'%03d'),'.jpg'];
    
    image_manmade = double(rgb2gray(imread(name_manmade)));
    image_animal = double(rgb2gray(imread(name_animal)));
    
    train_manmade = [train_manmade,image_manmade(:)];%each column is an image
    train_animal = [train_animal,image_animal(:)];%each column is an image
end

for i = 450:499
    name_manmade = [file_manmade,num2str(i,'%03d'),'.jpg'];
    name_animal = [file_animal,num2str(i,'%03d'),'.jpg'];
    
    image_manmade = rgb2gray(imread(name_manmade));
    image_animal = rgb2gray(imread(name_animal));
    
    test_manmade = [test_manmade,image_manmade(:)];%each column is an image
    test_animal = [test_animal,image_animal(:)];%each column is an image
end

train_xo = [train_manmade ,train_animal];
train_yo = [zeros([1,450]),ones([1,450])];
test_xo = [test_manmade ,test_animal];
test_yo = [zeros([1,50]),ones([1,50])];

%process data
all_data = [train_xo,test_xo];
m = mean(mean(all_data));
v = std(double(all_data),1,'all');
train_xo = (double(train_xo) - m)./v;
test_xo = (double(test_xo) - m)./v;



train_x = zeros([1024,900]);
train_y = zeros([1,900]);
test_x = zeros([1024,100]);
test_y = zeros([1,100]);

%Shuffle the sample order
a = [1:1:size(train_xo,2)];
b = a(randperm(numel(a)));
for i = 1:size(train_xo,2)
    train_x(:,i) = train_xo(:,b(i));
    train_y(:,i) = train_yo(:,b(i));
end
a = [1:1:size(test_xo,2)];
b = a(randperm(numel(a)));
for i = 1:size(test_xo,2)
    test_x(:,i) = test_xo(:,b(i));
    test_y(:,i) = test_yo(:,b(i));
end
train_x = num2cell(train_x,1);
test_x = num2cell(test_x,1);
train_y = num2cell(double(train_y),1);
test_y = num2cell(double(test_y),1);


test_accuracy = zeros([length(n),1]);
train_accuracy = zeros([length(n),1]);
for i = 1:length(n)
    net = train_seq(train_x,train_y,epochs,n(i));
    result_testx = net(test_x);
    result_trainx = net(train_x);

%culculate accuracy
    test_accuracy(i) = 1 - sum(abs((cell2mat(result_testx)>=0.5)-cell2mat(test_y)))/100;
    train_accuracy(i) = 1 - sum(abs((cell2mat(result_trainx)>=0.5)-cell2mat(train_y)))/900;
end

function net = train_seq(x,y,epochs,n )
 net =  patternnet(n);
 net.trainparam.goal=1e-10;
 net.trainFcn = 'trainscg';%Conjugate gradient backpropagation with Powell-Beale restarts
 net.layers{1}.transferFcn = 'tansig';%based on lecture 4
 net.layers{2}.transferFcn = 'logsig';%based on lecture 4
 %  Train the network in sequential mode
for i = 1 : epochs
    idx = randperm(length(x)); % shuffle the input
    net = adapt(net, x(:,idx), y(:,idx));
end
end