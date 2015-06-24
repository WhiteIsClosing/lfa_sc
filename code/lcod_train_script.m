datapath='USPS data/';
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
sp_code=load([datapath 'Sparse_Coef2.mat']);
sp_code=sp_code.Train_Set_sparse_vector;
dict=load([datapath 'Dictionary2.mat']);
dict=dict.Dict;
network=lcod_train(train_data,dict,sp_code,0.5,3,10);
save('trained_network/lcod_network.mat');