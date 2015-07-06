DATASET='MNIST';
ALPHA=0.5;
NET_DEPTH=1;
if strcmp(DATASET,'USPS')
  load(sprintf('trained_network/USPS_lcod_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('USPS Data/Dictionary2.mat');
  Wd=Wd.Dict;
  test_data=load('USPS Data/USPS_Test_Data.mat');
  test_data=test_data.Test_Data;
  IM_SIZE=[16 16];
elseif strcmp(DATASET,'MNIST')
  load(sprintf('trained_network/MNIST_lcod_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('MNIST Data/Simplified_MNIST_Dic.mat');
  Wd=Wd.WDict;
  test_data=load('MNIST Data/MNIST_Data.mat');
  test_data=test_data.tt_dat;
  IM_SIZE=[28 28];
end
base_sp_code=zeros(size(Wd,2),size(test_data,2));
sp_code=zeros(size(base_sp_code));
L=max(eig(Wd'*Wd))+1;
S=eye(size(Wd'*Wd))-(Wd'*Wd);
%%
bright_mul=8;
plot_flag=true;
for j=1:size(test_data,2)
  disp(j);
  sp_code(:,j)=lcod_fprop(test_data(:,j),network.We,network.S,network.theta,network.T);
  %%
  if plot_flag
    [base_sp_code(:,j),num_iter]=cod(test_data(:,j),Wd,S,ALPHA,0.0001,Inf);
    xp=Wd*sp_code(:,j);
    subplot(3,3,2);
    plot(test_data(:,j));
    subplot(3,3,3);
    imshow(reshape(test_data(:,j),IM_SIZE)*bright_mul);
    subplot(3,3,4);
    plot(base_sp_code(:,j));
    title('Ground truth sparse code');
    subplot(3,3,5);
    plot(Wd*base_sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,6);
    imshow(reshape(Wd*base_sp_code(:,j),IM_SIZE)*bright_mul);
    subplot(3,3,7);
    plot(sp_code(:,j));
    title('LCOD sparse code');
    subplot(3,3,8);
    plot(Wd*sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,9);
    imshow(reshape(xp,IM_SIZE)*bright_mul);
    pause;
  end
end
%%
err=test_data-Wd*sp_code;
clear result;
result.mean_absolute_error=mean(abs(err(:)));
result.mean_squared_error=mean(err(:).*err(:));
save(sprintf('lcod_result/%s_result_%f_%d.mat',DATASET,ALPHA,NET_DEPTH),'result');