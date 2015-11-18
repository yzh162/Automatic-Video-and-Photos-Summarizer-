function [sn,p]=find_similarity(all_images,gist)
N=size(all_images,2);
M=N*N-N; 
sn=zeros(M,3);
j=1;  
for i=1:N  
  for k=[1:i-1,i+1:N]  
    sn(j,1)=i; 
    sn(j,2)=k; 
    x1=gist(2*i-1,:);
    x2=gist(2*i,:);
    x3=gist(2*k-1,:);
    x4=gist(2*k,:);
    s1=-sum((x1-x3).^2);
    s2=-sum((x1-x4).^2);
    s3=-sum((x2-x3).^2);
    s4=-sum((x2-x4).^2);
    result=[s1,s2,s3,s4];
    sn(j,3)=max(result);
    j=j+1;  
  end;  
end; 
p=median(sn(:,3)); 