function[all_images,all_objects,image_names]=all_data(event,mapperlist,workpath)
data=importdata(event);
num=length(data);
for i=1:num
    data_line=regexp(data{i},'\t','split');
    url{i}=data_line{3};
end
mapper=importdata(mapperlist);
for i=1:num
    map_line=regexp(mapper{i},' ','split');
    param{1,i}=map_line{1};
    param{2,i}=map_line{2};
end
for i=1:num
    for j=1:num
        value=isequal(param{1,i},url{j});
        if value==1
            imagepath=strcat(workpath,param{2,i});
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
