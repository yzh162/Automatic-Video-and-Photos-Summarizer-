clc;
clear;
event='/Users/apple/Downloads/test.txt.imgs-boxes/test.txt.photos';
mapperlist='/Users/apple/Downloads/test.txt.imgs-boxes/mapper.list';
workplace='/Users/apple/Downloads/';


data=importdata(event);

num=length(data);
for i=1:num
    data_line=regexp(data{i},'\t','split');
    url{i}=data_line{3};
end
mapper=importdata(mapperlist);
for i=1:num
    map_line=regexp(mapper{i},' ','split');
    param{1,i}=map_line{1};             %
    param{2,i}=map_line{2};             %
end
kk=zeros(200,5);

for i=1:num
        if((boxes(i,5)-boxes(i,3))*(boxes(i,4)-boxes(i,2))>=30000)
                kk(i,:)=boxes(i,:);
        end
end


for i=1:num
    for j=1:num
        value=isequal(param{1,i},url{j});
        if value==1
            imagepath=strcat(workplace,param{2,i});
            boxpath=strcat(imagepath,'.boxes');
            boxes=load(boxpath);
            new_image=imread(imagepath);
            obj1=new_image(boxes(1,3):boxes(1,5),boxes(1,2):boxes(1,4),:);
            obj2=new_image(boxes(2,3):boxes(2,5),boxes(2,2):boxes(2,4),:);
            all_objects{2*i-1} = obj1;
            all_objects{2*i} = obj2;

            all_images{i}=new_image;
            parts=regexp(param{2,i},'/','split');
            image_names{i}=parts{end};
            break
        end
    end
end

gist=extract_features(all_objects);

%[sn,p]=find_similarity(all_images,gist);
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
p=min(sn(:,3)); 



[idx,netsim,dpsim,expref]=apcluster(sn,p,'');  
groups=unique(idx);
system(['mkdir ','ex']);
cd('ex');
for i=1:length(groups)
    exemplar{i}=all_images{groups(i)};
    exemplar_names{i}=image_names{groups(i)};
    imwrite(exemplar{i},exemplar_names{i});
end
cd('../')

