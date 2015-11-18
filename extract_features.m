function gist=extract_features(all_objects)
clear param
    param.imageSize = [256 256]; % it works also with non-square images
    param.orientationsPerScale = [8 8 8 8];
    param.numberBlocks = 4;
    param.fc_prefilt = 4;
for i=1:length(all_objects)
   [gist(i,:), param] = LMgist(all_objects{i}, '', param);
end